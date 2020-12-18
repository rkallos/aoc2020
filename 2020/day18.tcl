package require aoc

namespace eval day18 {
    namespace export part1 part2
}

proc day18::sGroup {listName op} {
    # turns "..a op b.." to "..{::tcl::mathop::op a b}.."
    upvar 1 $listName lst
    set pos [lsearch -exact $lst $op]
    set p_1 [expr {$pos-1}]
    set p1 [expr {$pos+1}]

    set op ::tcl::mathop::[lindex $lst $pos]
    set e1 [lindex $lst $p_1]
    set e2 [lindex $lst $p1]

    set lst [lreplace $lst $p_1 $p1 [list $op $e1 $e2]]
}

proc day18::s {args} {
    if {[llength $args]==1} {set args [lindex $args 0]}
    if [regexp {[()]} $args] {
        # replace "(a op b)" with "[s a op b]"
        set replacement [string map {"(" "\[s " ")" "]"} $args]
        eval s $replacement
    } elseif {[set opIdx [lsearch -exact -glob $args "\[*+\]"]] >= 0} {
        s [sGroup args [lindex $args $opIdx]]
    } else {
        # substitution is finished
        # prepare list for eval'ing
        string map {"{" "[" "}" "]"} [join $args]
    }
}

proc day18::part1 {input} {
    foreach e [aoc::nonEmptyLines $input] {incr sum [eval [s $e]]}
    return $sum
}
e.g. {day18::part1 "1 + 2 * 3 + 4 * 5 + 6\n"} -> 71
e.g. {day18::part1 "1 + (2 * 3) + (4 * (5 + 6))\n"} -> 51
e.g. {day18::part1 "2 * 3 + (4 * 5)\n"} -> 26
e.g. {day18::part1 "5 + (8 * 3 + 9 + 3 * 4 * 3)\n"} -> 437
e.g. {day18::part1 "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))\n"} -> 12240
e.g. {day18::part1 "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2\n"} -> 13632

proc day18::s2 {args} {
    if {[llength $args]==1} {set args [lindex $args 0]}
    if [regexp {[()]} $args] {
        # replace "(a op b)" with "[s2 a op b]"
        set replacement [string map {"(" "\[s2 " ")" "]"} $args]
        eval s2 $replacement
    } elseif {[lsearch -exact $args +] >= 0} {
        s2 [sGroup args +]
    } elseif {[lsearch -exact $args *] >= 0} {
        s2 [sGroup args *]
    } else {
        string map {"{" "[" "}" "]"} [join $args]
    }
}

proc day18::part2 {input} {
    foreach e [aoc::nonEmptyLines $input] {incr sum [eval [s2 $e]]}
    return $sum
}
e.g. {day18::part2 "1 + 2 * 3 + 4 * 5 + 6\n"} -> 231
e.g. {day18::part2 "1 + (2 * 3) + (4 * (5 + 6))\n"} -> 51
e.g. {day18::part2 "2 * 3 + (4 * 5)\n"} -> 46
e.g. {day18::part2 "5 + (8 * 3 + 9 + 3 * 4 * 3)\n"} -> 1445
e.g. {day18::part2 "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))\n"} -> 669060
e.g. {day18::part2 "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2\n"} -> 23340
