package require aoc

namespace eval day14 {
    namespace export part1 part2
}

set test [read [open [file dirname [info script]]/input/day14-test]]
set test2 [read [open [file dirname [info script]]/input/day14-test2]]

proc day14::applyMask {mask n} {
    set binStr [format {%.36b} $n]
    for {set i 0} {$i < [string length $mask]} {incr i} {
        set c [string index $mask $i]
        switch $c {
            X {continue}
            default {set binStr [string replace $binStr $i $i $c]}
        }
    }
    return [scan $binStr {%b}]
}
e.g. {day14::applyMask XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X 11} -> 73
e.g. {day14::applyMask XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X 0} -> 64

proc day14::part1 {input} {
    set instructions [aoc::nonEmptyLines $input]
    set mem [dict create]
    set mask 0
    foreach i $instructions {
        switch -glob -- $i {
            mask* {
                set mask [lindex [split $i] end]
            }
            mem* {
                set closeBracket [string first "]" $i]
                set addr [string range $i 4 $closeBracket-1]
                set val [lindex [split $i] end]
                dict set mem $addr [applyMask $mask $val]
            }
        }
    }
    return [::tcl::mathop::+ {*}[dict values $mem]]
}
e.g. {day14::part1 $test} -> 165

proc day14::replaceXs {binStr} {
    set idx [string last X $binStr]
    if {$idx == -1} {return [list $binStr]}
    set r0 [string replace $binStr $idx $idx 0]
    set r1 [string replace $binStr $idx $idx 1]
    set res {}
    lappend res {*}[replaceXs $r0]
    lappend res {*}[replaceXs $r1]
    return $res
}

proc day14::maskAddr {mask n} {
    set binStr [format {%.36b} $n]
    for {set i 0} {$i < [string length $mask]} {incr i} {
        set c [string index $mask $i]
        switch $c {
            0 {continue}
            default {set binStr [string replace $binStr $i $i $c]}
        }
    }
    set addrs [replaceXs $binStr]
    return [lmap a $addrs {scan $a {%b}}]
}
e.g. {lsort -integer [day14::maskAddr 000000000000000000000000000000X1001X 42]} -> {26 27 58 59}

proc day14::part2 {input} {
    set instructions [aoc::nonEmptyLines $input]
    set mem [dict create]
    set mask 0
    foreach i $instructions {
        switch -glob -- $i {
            mask* {
                set mask [lindex [split $i] end]
            }
            mem* {
                set closeBracket [string first "]" $i]
                set baseAddr [string range $i 4 $closeBracket-1]
                set addrs [maskAddr $mask $baseAddr]
                set val [lindex [split $i] end]
                foreach addr $addrs {
                    dict set mem $addr $val
                }
            }
        }
    }
    return [::tcl::mathop::+ {*}[dict values $mem]]
}
e.g. {day14::part2 $test2} -> 208
