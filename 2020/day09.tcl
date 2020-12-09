package require aoc

namespace eval day09 {
    namespace export part1 part2
}

set test "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"

proc day09::part1 {input {preamble 25}} {
    set numbers [aoc::nonEmptyLines $input]
    for {set idx $preamble} {$idx < [llength $numbers]} {incr idx} {
        set toCheck [lrange $numbers $idx-$preamble $idx-1]
        set needle [lindex $numbers $idx]
        set foundMatch 0
        foreach n $toCheck {
            set found [lsearch -integer $toCheck [expr {$needle-$n}]]
            if {$found != -1} {
                set foundMatch 1
                break
            }
        }
        if {!$foundMatch} {
            return $needle
        }
    }
    return 0
}
e.g. {day09::part1 $test 5} -> 127

proc day09::part2 {input {preamble 25}} {
    set numbers [aoc::nonEmptyLines $input]
    set needle [part1 $input $preamble]
    for {set idx1 0} {$idx1 < [llength $numbers]} {incr idx1} {
        for {set idx2 1} {$idx2 < [llength $numbers]} {incr idx2} {
            set l [lrange $numbers $idx1 $idx2]
            set sum [::tcl::mathop::+ {*}$l]
            if {$sum == $needle} {
                set min [::tcl::mathfunc::min {*}$l]
                set max [::tcl::mathfunc::max {*}$l]
                return [expr {$min + $max}]
            } elseif {$sum > $needle} {
                break
            }
        }
    }
}
e.g. {day09::part2 $test 5} -> [expr {15 + 47}]
