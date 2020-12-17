package require aoc

namespace eval day17 {
    namespace export part1 part2
}

set test ".#.\n..#\n###\n"

proc day17::neighbors {x y z} {
    set coords {}
    for {set dx -1} {$dx <= 1} {incr dx} {
        for {set dy -1} {$dy <= 1} {incr dy} {
            for {set dz -1} {$dz <= 1} {incr dz} {
                if {$dx == 0 && $dy == 0 && $dz == 0} {continue}
                set nx [expr {$x + $dx}]
                set ny [expr {$y + $dy}]
                set nz [expr {$z + $dz}]
                lappend coords "$nx,$ny,$nz"
            }
        }
    }
    return $coords
}

proc day17::generate {n oldGen {neighborsFun neighbors}} {
    set newGen [dict create]

    foreach cell [dict keys $oldGen] {
        foreach n [$neighborsFun {*}[split $cell ","]] {
            if {![dict exists $oldGen $n]} {
                dict set oldGen $n .
            }
        }
    }

    foreach cell [dict keys $oldGen] {
        # cell = "$x,$y,$z"
        set c [dict get $oldGen $cell]
        set neighborCells [lmap n [$neighborsFun {*}[split $cell ","]] {
            if {![dict exists $oldGen $n]} {
                list .
            } else {
                dict get $oldGen $n
            }
        }]
        set activeNeighbors [llength [lsearch -all $neighborCells @]]
        switch [list $c $activeNeighbors] {
            {@ 2} -
            {@ 3} {
                set newC @
            }
            {. 3} {
                set newC @
            }
            default {
                set newC .
            }
        }
        dict set newGen $cell $newC
    }
    return $newGen
}

proc day17::countActive {grid} {
    return [llength [lsearch -all [dict values $grid] @]]
}

proc day17::part1 {input} {
    set input [aoc::nonEmptyLines $input]
    set n 0
    set rows [split $input]
    set gens [dict create]
    for {set y 0} {$y < [llength $rows]} {incr y} {
        set row [string map {\# @} [lindex $rows $y]]
        for {set x 0} {$x < [string length $row]} {incr x} {
            set c [string index $row $x]
            dict set gens 0 "$x,$y,0" $c
        }
    }
    while {$n < 6} {
        set old [dict get $gens $n]
        incr n
        dict set gens $n [generate $n $old]
    }
    return [countActive [dict get $gens $n]]
}
e.g. {day17::part1 $test} -> 112

proc day17::neighbors2 {x y z w} {
    set coords {}
    for {set dx -1} {$dx <= 1} {incr dx} {
        for {set dy -1} {$dy <= 1} {incr dy} {
            for {set dz -1} {$dz <= 1} {incr dz} {
                for {set dw -1} {$dw <= 1} {incr dw} {
                if {$dx == 0 && $dy == 0 && $dz == 0 && $dw == 0} {continue}
                    set nx [expr {$x + $dx}]
                    set ny [expr {$y + $dy}]
                    set nz [expr {$z + $dz}]
                    set nw [expr {$w + $dw}]
                    lappend coords "$nx,$ny,$nz,$nw"
                }
            }
        }
    }
    return $coords
}

proc day17::part2 {input} {
    set input [aoc::nonEmptyLines $input]
    set n 0
    set rows [split $input]
    set gens [dict create]
    for {set y 0} {$y < [llength $rows]} {incr y} {
        set row [string map {\# @} [lindex $rows $y]]
        for {set x 0} {$x < [string length $row]} {incr x} {
            set c [string index $row $x]
            dict set gens 0 "$x,$y,0,0" $c
        }
    }
    while {$n < 6} {
        set old [dict get $gens $n]
        incr n
        dict set gens $n [generate $n $old neighbors2]
    }
    return [countActive [dict get $gens $n]]
}
e.g. {day17::part2 $test} -> 848
