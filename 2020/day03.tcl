package require aoc

namespace eval day03 {
    namespace export part1 part2
}

set test "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"

proc day03::descend {lines slope} {
    lassign $slope down right
    set r 0; set c 0; set trees 0
    while {$r < [llength $lines]} {
        set row [lindex $lines $r]
        if {"#" == [string index $row [expr {$c % [string length $row]}]]} {
            incr trees
        }
        incr r $down
        incr c $right
    }
    return $trees
}

proc day03::part1 {input} {
    return [descend $input {1 3}]
}
e.g. {day03::part1 $test} -> 7

proc day03::part2 {input} {
    set slopes {{1 1} {1 3} {1 5} {1 7} {2 1}}
    return [::tcl::mathop::* {*}[lmap slope $slopes {descend $input $slope}]]
}
e.g. {day03::part2 $test} -> 336
