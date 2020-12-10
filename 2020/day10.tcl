package require aoc

namespace eval day10 {
    namespace export part1 part2
}

proc day10::part1 {input} {
    set lst [linsert [lsort -integer [aoc::nonEmptyLines $input]] 0 0]
    lappend lst [expr {3 + [lindex $lst end]}]
    for {set idx 1} {$idx < [llength $lst]} {incr idx} {
        switch [expr {[lindex $lst $idx] - [lindex $lst $idx-1]}] {
            1 {incr 1s}
            3 {incr 3s}
        }
    }
    return [expr {$1s * $3s}]
}

proc day10::part2 {input} {
    set lst [linsert [lsort -integer [aoc::nonEmptyLines $input]] 0 0]
    set max [expr {3 + [lindex $lst end]}]
    lappend lst $max

    # bottom-up dynamic programming
    set g [dict create]
    set paths [list $max 1]
    for {set idx [expr {[llength $lst] - 2}]} {$idx >= 0} {incr idx -1} {
        set a [lindex $lst $idx]
        set compatible [lmap i {1 2 3} {expr {$a+$i}}]
        set edges [lsearch -all -inline -regexp $lst "^([join $compatible |])$"]
        set nPaths [::tcl::mathop::+ {*}[lmap e $edges {dict get $paths $e}]]
        dict set paths $a $nPaths
    }
    return [dict get $paths 0]
}

source [file dirname [info script]]/day10.test
