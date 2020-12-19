package require aoc

namespace eval day19 {
    namespace export part1 part2
}

set test "0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"

proc day19::makeRules {rs} {
    set rules [dict create]
    foreach r $rs {
        set colon [string first ":" $r]
        set name [string range $r 0 $colon-1]
        set lowers [string range $r $colon+2 end]
        foreach lower [split $lowers "|"] {
            if {[lindex $lower 0] in {a b}} {
                dict lappend rules $name [lindex $lower 0]
            } else {
                dict lappend rules $name [string trim $lower]
            }
        }
    }
    return $rules
}

proc day19::head {l} {return [lindex $l 0]}
proc day19::tail {l} {return [lrange $l 1 end]}

proc day19::check {str rule} {
    variable rules
    # base case: No rules left. Check if string is fully consumed
    if {$rule == {}} {return [expr {[string length $str] == 0}]}

    set lowers [dict get $rules [head $rule]]
    set rule [tail $rule]
    if {$lowers in {a b}} {
        # rule is a literal. Check for match then recur
        return [expr {[string head $str] == $lowers && [check [string tail $str] $rule]}]
    } else {
        # rule is a sequence of sequences. OR them.
        foreach lower $lowers {
            if {[check $str [linsert $rule 0 {*}$lower]]} {
                return 1
            }
        }
        return 0
    }
}

proc day19::part1 {input} {
    variable rules
    set break [string first "\n\n" $input]
    set rs [aoc::nonEmptyLines [string range $input 0 $break]]
    set ls [aoc::nonEmptyLines [string range $input $break+2 end]]

    set rules [makeRules $rs]
    set nMatching 0
    foreach l $ls {
        set matches [check $l {0}]
        if {$matches} {incr nMatching}
    }
    return $nMatching
}
e.g. {day19::part1 $test} -> 2

proc day19::part2 {input} {
    variable rules
    set break [string first "\n\n" $input]
    set rs [aoc::nonEmptyLines [string range $input 0 $break]]
    set ls [aoc::nonEmptyLines [string range $input $break+2 end]]

    set rules [makeRules $rs]
    dict set rules 8 {{42} {42 8}}
    dict set rules 11 {{42 31} {42 11 31}}
    set nMatching 0
    foreach l $ls {
        set matches [check $l {0}]
        if {$matches} {incr nMatching}
    }
    return $nMatching
    return 0
}

source [file dirname [info script]]/day19.test
e.g. {day19::part1 $test2} -> 3
e.g. {day19::part2 $test2} -> 12
