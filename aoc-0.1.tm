namespace eval aoc {
    namespace export nonEmptyLines countLines lineClusters
}

proc aoc::nonEmptyLines {input} {
    return [lsearch -all -inline -not [split $input "\n"] {}]
}

proc aoc::countLines {pred lines} {
    set n 0
    foreach line $lines {
        if {[uplevel 1 "$pred {$line}"]} {incr n}
    }
    return $n
}

proc aoc::lineClusters {input} {
    # a trick to split on a multi-character sequence;
    # map the sequence to a single character you don't expect.
    set grouped [split [string map {"\n\n" \u0080} $input] \u0080]
    lmap p $grouped {string map {"\n" " " : " "} $p}
}

proc aoc::manhattan args {
    ::tcl::mathop::+ {*}[lmap a $args {::tcl::mathfunc::abs $a}]
}
