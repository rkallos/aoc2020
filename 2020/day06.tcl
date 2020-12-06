package require aoc

namespace eval day06 {
    namespace export part1 part2
}

set day06::test "abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na\n\nb"

proc day06::CountQuestions {group} {
    set d [dict create]
    foreach line $group {
        foreach c [split $line ""] {
            dict incr d $c 1
        }
    }
    return $d
}

proc day06::part1 {input} {
    set groups [aoc::lineClusters $input]
    set counts [lmap g $groups {llength [dict keys [CountQuestions $g]]}]
    return [tcl::mathop::+ {*}$counts]
}
e.g. {day06::part1 $day06::test} -> 11

proc day06::part2 {input} {
    set res 0
    foreach group [aoc::lineClusters $input] {
        dict for {k v} [CountQuestions $group] {
            if {$v == [llength $group]} {incr res}
        }
    }
    return $res
}
e.g. {day06::part2 $day06::test} -> 6
