package require aoc

namespace eval day11 {
    namespace export part1 part2
}

set test "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"

proc day11::adjacent {grid r c} {
    set res 0
    for {set dr -1} {$dr <= 1} {incr dr} {
        for {set dc -1} {$dc <= 1} {incr dc} {
            if {$dr == 0 && $dc == 0} {continue}
            if {[string index [lindex $grid $r+$dr] $c+$dc] == "#"} {
                incr res
            }
        }
    }
    return $res
}

proc day11::advance {grid {threshold 4} {adjacent adjacent}} {
    set new {}
    for {set row 0} {$row < [llength $grid]} {incr row} {
        set newRow ""
        set rowChars [lindex $grid $row]
        for {set col 0} {$col < [string length $rowChars]} {incr col} {
            set c [string index $rowChars $col]
            switch $c {
                L {
                    if {[$adjacent $grid $row $col] == 0} {
                        append newRow \#
                    } else {
                        append newRow L
                    }
                }
                \# {
                    if {[$adjacent $grid $row $col] >= $threshold} {
                        append newRow L
                    } else {
                        append newRow \#
                    }
                }
                default {
                    append newRow $c
                }
            }
        }
        lappend new $newRow
    }
    return $new
}

proc day11::part1 {input} {
    set grid [aoc::nonEmptyLines $input]
    set gen 0
    while 1 {
        set next [advance $grid]
        if {$next == $grid} {
            set res 0
            foreach row $next {
                incr res [llength [lsearch -all [split $row ""] "#"]]
            }
            return $res
        }
        incr gen
        set grid $next
    }
}
e.g. {day11::part1 $test} -> 37

proc day11::adjacent2 {grid r c} {
    set res 0
    for {set dr -1} {$dr <= 1} {incr dr} {
        for {set dc -1} {$dc <= 1} {incr dc} {
            if {$dr == 0 && $dc == 0} {continue}
            set r2 [expr {$r+$dr}]
            set c2 [expr {$c+$dc}]
            while {$r2 >= 0 && $r2 < [llength $grid] && $c2 >= 0 && $c2 < [string length [lindex $grid 0]]} {
                set ch [string index [lindex $grid $r2] $c2]
                if {$ch == "#"} {
                    incr res
                    break
                } elseif {$ch == "L"} {
                    break
                }
                incr r2 $dr
                incr c2 $dc
            }
        }
    }
    return $res
}

e.g. {day11::adjacent2 ".......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#....." 4 3} -> 8

proc day11::part2 {input} {
    set grid [aoc::nonEmptyLines $input]
    set gen 0
    while 1 {
        set next [advance $grid 5 adjacent2]
        if {$next == $grid} {
            set res 0
            foreach row $next {
                incr res [llength [lsearch -all [split $row ""] "#"]]
            }
            return $res
        }
        incr gen
        set grid $next
    }
}
e.g. {day11::part2 $test} -> 26
