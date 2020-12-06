package require aoc

namespace eval day06 {
    namespace export part1 part2
}

set day06::test "abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na\n\nb"

proc day06::CountQuestions {group} {
    set d [dict create]
    lmap line $group {lmap c [split $line ""] {dict incr d $c}}
    return $d
}

proc day06::CountMatches {d pat} {
    return [llength [dict values $d $pat]]
}

proc day06::part1 {input} {
    set groups [aoc::lineClusters $input]
    set counts [lmap g $groups {CountMatches [CountQuestions $g] *}]
    return [tcl::mathop::+ {*}$counts]
}
e.g. {day06::part1 $day06::test} -> 11

proc day06::part2 {input} {
    set groups [aoc::lineClusters $input]
    set counts [lmap g $groups {CountMatches [CountQuestions $g] [llength $g]}]
    return [tcl::mathop::+ {*}$counts]
}
e.g. {day06::part2 $day06::test} -> 6
