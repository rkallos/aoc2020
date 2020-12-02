namespace eval day02 {

# added an extra 'c' line to test the outer boundary
set test "1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
2-9 c: cccccccccc
"

set rx {([1-9][0-9]*)-([1-9][0-9]*) ([a-z]): ([a-z]+)}

proc countLines {pred input} {
    set n 0
    foreach line [lsearch -all -inline -not [split $input "\n"] {}] {
        if {[$pred $line]} {incr n}
    }
    return $n
}

proc matchOccurrences {line} {
    variable rx
    regexp $rx $line _ lo hi l pass
    set count [llength [lsearch -all [split $pass {}] $l]]
    return [expr {$count >= $lo && $count <= $hi}]
}

proc part1 {input} {
    return [countLines matchOccurrences $input]
}
# see comment above
e.g. {part1 $test} -> 2

proc checkIndices {line} {
    variable rx
    regexp $rx $line _ i1 i2 l pass
    set n 0
    foreach c "[string index $pass $i1-1] [string index $pass $i2-1]" {
        if {$c == $l} {incr n}
    }
    return [expr {$n == 1}]
}

proc part2 {input} {
    return [countLines checkIndices $input]
}
e.g. {part2 $test} -> 1

}
