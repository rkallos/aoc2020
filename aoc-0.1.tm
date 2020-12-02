namespace eval aoc {
    namespace export nonEmptyLines countLines

proc nonEmptyLines {input} {
    return [lsearch -all -inline -not [split $input "\n"] {}]
}

proc countLines {pred lines} {
    set n 0
    foreach line $lines {
        if {[uplevel 1 "$pred {$line}"]} {incr n}
    }
    return $n
}
}
