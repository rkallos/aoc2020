package require aoc

namespace eval day15 {
    namespace export part1 part2
}

proc day15::part1 {input {lastTurn 2020}} {
    set turn 1
    set 1ago [dict create]
    set n 0
    set init [split $input ","]
    foreach i [lrange $init 0 end-1] {
        dict set 1ago $i $turn
        incr turn
    }
    set n [lindex $init end]
    while {$turn < $lastTurn} {
        if {![dict exists $1ago $n]} {
            set new 0
        } else {
            set new [expr {$turn - [dict get $1ago $n]}]
        }
        dict set 1ago $n $turn
        set n $new
        incr turn
    }
    return $n
}
e.g. {day15::part1 "0,3,6"} -> 436
e.g. {day15::part1 "1,3,2"} -> 1
e.g. {day15::part1 "2,1,3"} -> 10
e.g. {day15::part1 "1,2,3"} -> 27
e.g. {day15::part1 "2,3,1"} -> 78
e.g. {day15::part1 "3,2,1"} -> 438
e.g. {day15::part1 "3,1,2"} -> 1836

proc day15::part2 {input} {
    return [part1 $input 30000000]
}
