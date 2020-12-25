package require aoc

namespace eval day25 {
    namespace export part1 part2
}

set test "5764801
17807724
"

proc day25::calc {n {s 7}} {return [expr {($n * $s) % 20201227}]}

proc day25::part1 {input} {
    lassign [aoc::nonEmptyLines $input] key1 key2
    set loop1 1
    set v1 7
    while {$v1 != $key1} {
        set v1 [calc $v1]
        incr loop1
    }

    set loop2 1
    set v2 7
    while {$v2 != $key2} {
        set v2 [calc $v2]
        incr loop2
    }

    set v3 $key1
    for {set i 1} {$i < $loop2} {incr i} {
        set v3 [calc $v3 $key1]
    }
    return $v3
}
e.g. {day25::part1 $test} -> 14897079

proc day25::part2 {input} {return 0}
