package require aoc

namespace eval day12 {
    namespace export part1 part2
}

set test "F10
N3
F7
R90
F11"

proc day12::turn {facing dir amount} {
    set dirs {N E S W}
    set dirIdx [lsearch $dirs $facing]
    set amount [expr {$amount / 90}]
    if {$dir == "L"} {set amount -$amount}
    set newIdx [expr {($dirIdx + $amount) % 4}]
    return [lindex $dirs $newIdx]
}
e.g. {day12::turn N R 90} -> E
e.g. {day12::turn N L 90} -> W
e.g. {day12::turn E L 180} -> W
e.g. {day12::turn E R 180} -> W
e.g. {day12::turn S L 270} -> W

proc day12::part1 {input} {
    set steps [aoc::nonEmptyLines $input]
    set x 0
    set y 0
    set facing E
    foreach step $steps {
        set dir [string index $step 0]
        set amount [string range $step 1 end]
        switch $dir {
            N {incr y $amount}
            E {incr x $amount}
            S {incr y -$amount}
            W {incr x -$amount}
            R {set facing [turn $facing R $amount]}
            L {set facing [turn $facing L $amount]}
            F {switch $facing {
                N {incr y $amount}
                E {incr x $amount}
                S {incr y -$amount}
                W {incr x -$amount}
            }
            }
        }
    }
    return [aoc::manhattan $x $y]
}
e.g. {day12::part1 $test} -> 25

proc day12::turnWaypoint {dir amt wayx wayy} {
    switch -glob $amt$dir {
        180* {return [list [expr {-$wayx}] [expr {-$wayy}]]}
        90cw - 270ccw {return [list $wayy [expr {-$wayx}]]}
        90ccw - 270cw {return [list [expr {-$wayy}] $wayx]}
    }
}
e.g. {day12::turnWaypoint ccw 180 10 4} -> {-10 -4}
e.g. {day12::turnWaypoint cw 90 10 4} -> {4 -10}

proc day12::part2 {input} {
    set steps [aoc::nonEmptyLines $input]
    set shipx 0
    set shipy 0
    set wayx 10
    set wayy 1
    foreach step $steps {
        set dir [string index $step 0]
        set amount [string range $step 1 end]
        switch $dir {
            N {incr wayy $amount}
            E {incr wayx $amount}
            S {incr wayy -$amount}
            W {incr wayx -$amount}
            R {lassign [turnWaypoint cw $amount $wayx $wayy] wayx wayy}
            L {lassign [turnWaypoint ccw $amount $wayx $wayy] wayx wayy}
            F {
                incr shipx [expr {$wayx * $amount}]
                incr shipy [expr {$wayy * $amount}]
            }
        }
    }
    return [aoc::manhattan $shipx $shipy]
}
e.g. {day12::part2 $test} -> 286
