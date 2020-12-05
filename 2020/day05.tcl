package require aoc

namespace eval day05 {
    namespace export part1 part2
}

proc day05::SeatId {str} {
    return [scan [string map {F 0 B 1 L 0 R 1} $str] {%b}]
}
e.g. {day05::SeatId FBFBBFFRLR} -> 357
e.g. {day05::SeatId BFFFBBFRRR} -> 567
e.g. {day05::SeatId FFFBBBFRRR} -> 119
e.g. {day05::SeatId BBFFBBFRLL} -> 820

proc day05::SeatIds {input} {
    return [lmap i $input {SeatId $i}]
}

proc day05::part1 {input} {
    return [::tcl::mathfunc::max {*}[SeatIds $input]]
}

proc day05::part2 {input} {
    foreach {id1 id2} [lsort -integer [SeatIds $input]] {
        if {$id1 + 1 != $id2} {
            return [expr {$id1 + 1}]
        }
    }
}
