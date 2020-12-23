package require aoc

namespace eval day23 {
    namespace export part1 part2
}
# for repeated source-ing
catch {Cup destroy}

# simple linked list, because I don't trust Tcl lists to do the right thing
oo::class create Cup
oo::define Cup {
variable label
variable next
constructor {l} {
    set label $l
    set next none
}

method label {} {return $label}
method next {} {return $next}
method setNext {cup} {set next $cup}
method setPrev {cup} {$cup setNext [self object]}

method take {nCups} {
    set res $next
    set last $next
    for {set i $nCups} {$i > 0} {incr i -1} {
        if {$i == 1} {
            set beforeLast $last
        }
        set last [$last next]
    }
    $beforeLast setNext none
    set next $last
    return $res
}

method insert {cups} {
    set last $cups
    while {[$last next] != {none}} {set last [$last next]}
    $last setNext $next
    set next $cups
}

method search {needle} {
    if {$label == $needle} {return 0}
    set ptr $next
    set i 1
    while {$ptr != {none}} {
        if {[$ptr label] == $needle} {return $i}
        set ptr [$ptr next]
        incr i
    }
    return -1
}
}

set test "389125467\n"

proc makeCups {labels} {
    set lookup [dict create]
    set first [Cup new [lindex $labels 0]]
    dict set lookup [lindex $labels 0] $first
    set last $first
    foreach label [lrange $labels 1 end] {
        set new [Cup new $label]
        dict set lookup $label $new
        $new setPrev $last
        set last $new
    }
    $last setNext $first
    return $lookup
}

proc play {labels lookup {moves 100}} {
    set move 1
    set curLabel [lindex $labels 0]
    while {$move <= $moves} {
        puts -nonewline "\r$move/$moves"
        set curCup [dict get $lookup $curLabel]
        set pickedUpCups [$curCup take 3]
        set dstLabel [expr {($curLabel-1) == 0 ? [llength $labels] : $curLabel-1}]
        while {[$pickedUpCups search $dstLabel] != -1} {
            set dstLabel [expr {($dstLabel-1) == 0 ? [llength $labels] : $dstLabel-1}]
        }
        set dstCup [dict get $lookup $dstLabel]
        $dstCup insert $pickedUpCups
        set curLabel [[$curCup next] label]
        incr move
    }
    puts ""
}

proc day23::part1 {input {moves 100}} {
    set labels [split [lindex [aoc::nonEmptyLines $input] 0] ""]
    set lookup [makeCups $labels]
    play $labels $lookup $moves
    set start [[dict get $lookup 1] next]
    set res {}
    for {set i 0} {$i < 8} {incr i} {
        lappend res [$start label]
        set start [$start next]
    }
    return [join $res ""]
}
e.g. {day23::part1 $test 10} -> 92658374
e.g. {day23::part1 $test 100} -> 67384529

proc day23::part2 {input {moves 10000000}} {
    set labels [split [lindex [aoc::nonEmptyLines $input] 0] ""]
    puts "making a list"
    for {set i [expr {[llength $labels]+1}]} {$i <= 1000000} {incr i} {
        lappend labels $i
    }
    puts "there are [llength $labels] cups"
    puts "checking it twice"
    set lookup [makeCups $labels]
    play $labels $lookup $moves
    set a [[dict get $lookup 1] next]
    set b [$a next]
    return [expr {[$a label] * [$b label]}]
}
e.g. {day23::part2 $test} -> 149245887792
