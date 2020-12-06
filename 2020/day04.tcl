package require aoc

namespace eval day04 {
    namespace export part1 part2
}

proc day04::PassportsWithoutMissingFields {passports} {
    set result {}
    foreach p $passports {
        if {[dict exists $p cid]} {
            set threshold 8
        } else {
            set threshold 7
        }
        if {[dict size $p] < $threshold} {
            continue
        }
        lappend result $p
    }
    return $result
}

proc day04::part1 {input} {
    return [llength [PassportsWithoutMissingFields [aoc::lineClusters $input]]]
}

proc day04::byr {v} {return [expr {$v >= 1920 && $v <= 2002}]}

proc day04::iyr {v} {return [expr {$v >= 2010 && $v <= 2020}]}

proc day04::eyr {v} {return [expr {$v >= 2020 && $v <= 2030}]}

proc day04::hgt {v} {
    set res 0
    if {[scan $v "%d%s" n unit] == 2} {
        switch $unit {
            in {set res [expr {$n >= 59 && $n <= 76}]}
            cm {set res [expr {$n >= 150 && $n <= 193}]}
        }
    }
    return $res
}

proc day04::hcl {v} {
    return [expr {[regexp {^\#[0-9a-f]{6}$} $v]}]
}

proc day04::ecl {v} {
    return [expr {$v in {amb blu brn gry grn hzl oth}}]
}

proc day04::pid {v} {
    return [expr {[regexp {^[0-9]{9}$} $v]}]
}

proc day04::cid {v} {
    return 1
}

proc day04::IsValidPassport {passport} {
    dict for {f v} $passport {
        if {![$f $v]} {
            return 0
        }
    }
    return 1
}

proc day04::part2 {input} {
    set result 0
    foreach p [PassportsWithoutMissingFields [aoc::lineClusters $input]] {
        if {[IsValidPassport $p]} {
            incr result
        }
    }
    return $result
}

source [file dirname [info script]]/day04.test
