package require aoc

namespace eval day02 {
    namespace export part1 part2
}

# added an extra 'c' line to test the outer boundary
set test "1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
2-9 c: cccccccccc
"

proc matchOccurrences {line} {
    scan $line {%d-%d %[a-z]: %s} lo hi l pass
    set count [llength [lsearch -all [split $pass {}] $l]]
    return [expr {$count >= $lo && $count <= $hi}]
}

proc day02::part1 {input} {
    return [aoc::countLines matchOccurrences [aoc::nonEmptyLines $input]]
}
# see comment above
e.g. {day02::part1 $test} -> 2

proc checkIndices {line} {
    scan $line {%d-%d %[a-z]: %s} i1 i2 l pass
    set n 0
    foreach c "[string index $pass $i1-1] [string index $pass $i2-1]" {
        if {$c == $l} {incr n}
    }
    return [expr {$n == 1}]
}

proc day02::part2 {input} {
    return [aoc::countLines checkIndices [aoc::nonEmptyLines $input]]
}
e.g. {day02::part2 $test} -> 1
