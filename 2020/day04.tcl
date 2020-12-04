package require aoc

namespace eval day04 {
    namespace export part1 part2
}

set test "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"

proc day04::passports {input} {
    # a trick to split on a multi-character sequence;
    # map the sequence to a single character you don't expect.
    set grouped [split [string map {"\n\n" \u0080} $input] \u0080]
    lmap p $grouped {string map {"\n" " " : " "} $p}
}

proc day04::part1 {input} {
    set passports [passports $input]
    set result 0
    foreach p $passports {
        if {[dict exists $p cid]} {set t 8} else {set t 7}
        if {[dict size $p] < $t} {continue}
        incr result
    }
    return $result
}
e.g. {day04::part1 $test} -> 2

set valid "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"

set invalid "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"
proc day04::byr {v} {return [expr {$v >= 1920 && $v <= 2002}]}
e.g. {day04::byr 1919} -> 0
e.g. {day04::byr 2002} -> 1
e.g. {day04::byr 2003} -> 0

proc day04::iyr {v} {return [expr {$v >= 2010 && $v <= 2020}]}
e.g. {day04::iyr 2009} -> 0
e.g. {day04::iyr 2015} -> 1
e.g. {day04::iyr 2021} -> 0

proc day04::eyr {v} {return [expr {$v >= 2020 && $v <= 2030}]}
e.g. {day04::eyr 2019} -> 0
e.g. {day04::eyr 2025} -> 1
e.g. {day04::eyr 2031} -> 0

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
e.g. {day04::hgt 60in} -> 1
e.g. {day04::hgt 190cm} -> 1
e.g. {day04::hgt 190in} -> 0
e.g. {day04::hgt 190} -> 0

proc day04::hcl {v} {
    return [expr {[regexp {^\#[0-9a-f]{6}$} $v]}]
}
e.g. {day04::hcl #123abc} -> 1
e.g. {day04::hcl #123abz} -> 0
e.g. {day04::hcl 123abc} -> 0

proc day04::ecl {v} {
    return [expr {$v in {amb blu brn gry grn hzl oth}}]
}
e.g. {day04::ecl brn} -> 1
e.g. {day04::ecl wat} -> 0

proc day04::pid {v} {
    return [expr {[regexp {^[0-9]{9}$} $v]}]
}
e.g. {day04::pid 000000001} -> 1
e.g. {day04::pid 0123456789} -> 0

proc day04::cid {v} {
    return 1
}
e.g. {day04::cid anything} -> 1

proc day04::part2 {input} {
    set passports [passports $input]
    set result 0
    foreach p $passports {
        if {[dict exists $p cid]} {set t 8} else {set t 7}
        if {[dict size $p] < $t} {continue}
        set ok 1
        dict for {f v} $p {
            if {![$f $v]} {
                set ok 0
                break
            }
        }
        if {$ok} {
            incr result
        }
    }
    return $result
}
e.g. {day04::part2 $test} -> 3
e.g. {day04::part2 $valid} -> 4
e.g. {day04::part2 $invalid} -> 0
