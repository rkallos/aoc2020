package require aoc

namespace eval day08 {
    namespace export part1 part2
}

set test "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"

proc day08::nop {arg} {uplevel 1 "incr ip"}
proc day08::acc {arg} {uplevel 1 "incr acc $arg; incr ip"}
proc day08::jmp {arg} {uplevel 1 "incr ip $arg"}

proc day08::run {code} {
    set ip 0
    set acc 0
    set seen [dict create]
    while 1 {
        if {$ip > [llength $code] - 1} {
            return [list 1 $acc]
        }
        if {[dict exists $seen $ip]} {
            return [list 0 $acc]
        }
        dict set seen $ip 1
        set line [lindex $code $ip]
        eval $line
    }
}

proc day08::part1 {input} {
    lassign [run [aoc::nonEmptyLines $input]] _ acc
    return $acc
}
e.g. {day08::part1 $test} -> 5

proc day08::newOp {line} {
    switch -glob $line {
        "jmp *" {return "nop"}
        "nop *" {return "jmp"}
    }
}

proc day08::part2 {input} {
    set code [aoc::nonEmptyLines $input]
    set replacements [lsearch -glob -all $code "jmp *"]
    lappend replacements [lsearch -glob -all $code "nop *"]
    foreach idx $replacements {
        set line [lindex $code $idx]
        lassign $line _ arg
        set newCode [lreplace $code $idx $idx "[newOp $line] $arg"]
        lassign [run $newCode] terminates acc
        if {$terminates} {return $acc}
    }
}
e.g. {day08::part2 $test} -> 8
