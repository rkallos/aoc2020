package require aoc

namespace eval day07 {
    namespace export part1 part2
}

set test "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"

proc Edges {line} {
    set firstBags [expr {[string first " bags" $line] - 1}]
    set dstColor [string range $line 0 $firstBags]
    set srcsStr [string range $line [string first " contain " $line]+9 end]
    set srcs [lmap s [split $srcsStr ,] {
        if {![regexp -- {^ *(\d+) (.+) bag} $s -> num color]} {
            continue
        }
        list $color $num
    }]
    return [list $dstColor $srcs]
}

proc day07::part1 {input} {
    set g [dict create]
    set i 1
    foreach l [split $input \n] {
        lassign [Edges $l] dst srcs
        if {![dict exists $g $dst]} {
            dict set g $dst [dict create]
        }
        foreach srcPair $srcs {
            lassign $srcPair srcColor srcNum
            if {![dict exists $g $srcColor]} {
                dict set g $srcColor [dict create]
            }
            dict set g $srcColor $dst $srcNum
        }
    }
    set needle "shiny gold"
    set next [list $needle]
    set visited {}
    dict set visited $needle 1
    set reachable [dict create]
    while {$next != {}} {
        set current $next
        set next {}
        foreach n $current {
            dict for {out weight} [dict get $g $n] {
                dict set reachable $out $weight
                if {![dict exists $visited $out]} {
                    lappend next $out
                }
            }
            dict set $visited $n 1
        }
    }
    return [dict size $reachable]
}
e.g. {day07::part1 $test} -> 4

set test2 "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."

proc countBags {gName memoName color} {
    upvar $gName g $memoName memo
    if {[dict exists $memo $color]} {
        return [dict get $memo $color]
    }
    set contents [dict get $g $color]
    set res 0
    dict for {nextColor num} [dict get $g $color] {
        incr res $num
        incr res [expr {$num * [countBags $gName $memoName $nextColor]}]
    }
    dict set memo $color $res
    return $res
}

proc day07::part2 {input} {
    set g [dict create]
    set i 1
    foreach l [split $input \n] {
        lassign [Edges $l] src dsts
        if {![dict exists $g $src]} {
            dict set g $src [dict create]
        }
        foreach dstPair $dsts {
            lassign $dstPair dstColor dstNum
            dict set g $src $dstColor $dstNum
        }
    }
    set memo [dict create]
    return [countBags g memo "shiny gold"]
}
e.g. {day07::part2 $test} -> 32
e.g. {day07::part2 $test2} -> 126
