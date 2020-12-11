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

# Alternative implementation of part 2 using tribonacci numbers
# proc day10::tribonacci {n {a 1} {b 2} {c 4}} {
#     switch $n {
#         1 {return $a}
#         2 {return $b}
#         3 {return $c}
#         default {
#             tailcall tribonacci [expr {$n - 1}] $b $c [expr {$a + $b + $c}]
#         }
#     }
# }
# e.g. {day10::tribonacci 1} -> 1
# e.g. {day10::tribonacci 2} -> 2
# e.g. {day10::tribonacci 3} -> 4
# e.g. {day10::tribonacci 4} -> 7
# e.g. {day10::tribonacci 5} -> 13
# e.g. {day10::tribonacci 6} -> 24
#
# proc day10::part2 {input} {
#     set lst [linsert [lsort -integer [aoc::nonEmptyLines $input]] 0 0]
#     set max [expr {3 + [lindex $lst end]}]
#     lappend lst $max
#
#     set runs {}
#     set consecutive 0
#     for {set i 1} {$i < [llength $lst]} {incr i} {
#         set a [lindex $lst [expr {$i - 1}]]
#         set b [lindex $lst $i]
#         if {$b-$a == 1} {
#             incr consecutive
#             continue
#         }
#         if {$consecutive == 0} {continue}
#         lappend runs $consecutive
#         set consecutive 0
#     }
#     return [tcl::mathop::* {*}[lmap r $runs {tribonacci $r}]]
# }

source [file dirname [info script]]/day10.test
