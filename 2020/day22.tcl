package require aoc

namespace eval day22 {
    namespace export part1 part2
}

set test "Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
"

proc deckScore {deck} {
    set res 0
    for {set i 0} {$i < [llength $deck]} {incr i} {
        incr res [expr {($i+1) * [lindex $deck end-$i]}]
    }
    return $res
}

proc day22::part1 {input} {
    set 2nl [string first "\n\n" $input]
    # I love when the input is (almost) valid tcl code
    set p1 [list {*}[string range $input [string first "\n" $input] $2nl]]
    set p2 [list {*}[string range $input [string first "\n" $input $2nl+2] end]]

    while {[llength $p1] > 0 && [llength $p2] > 0} {
        set p1 [lassign $p1 p1Card]
        set p2 [lassign $p2 p2Card]
        switch [expr {$p1Card > $p2Card}] {
            1 {lappend p1 $p1Card $p2Card}
            0 {lappend p2 $p2Card $p1Card}
        }
    }
    # one deck is guaranteed to be empty, hence the concat for the winner's deck
    return [deckScore [concat $p1 $p2]]
}
e.g. {day22::part1 $test} -> 306

proc round {p1 p2} {
    set seen [dict create]
    while {[llength $p1] > 0 && [llength $p2] > 0} {
        if {[dict exists $seen [list $p1 $p2]]} {
            #puts "Infinite loop! Player 1 wins!"
            return [list $p1 $p1 $p2]
        } else {
            dict set seen [list $p1 $p2] 1
        }
        set p1 [lassign $p1 p1Card]
        set p2 [lassign $p2 p2Card]
        # res should be 1 if player 1 wins, and 2 if player 2 wins
        # as a result, deciding a normal round should be 1+($p2 > $p1)
        # and deciding a recursive round should be 1+($w == $d2)
        if {[llength $p1] >= $p1Card && [llength $p2] >= $p2Card} {
            #puts "Recursion alert! Starting sub-game"
            set p1New [lrange $p1 0 $p1Card-1]
            set p2New [lrange $p2 0 $p2Card-1]
            lassign [round $p1New $p2New] w d1 d2
            set res [expr {($w eq $d2) + 1}]
        } else {
            set res [expr {($p2Card > $p1Card) + 1}]
        }
        switch $res {
            1 {lappend p1 $p1Card $p2Card}
            2 {lappend p2 $p2Card $p1Card}
        }
    }
    set w [expr {([llength $p1] > [llength $p2]) ? $p1 : $p2}]
    return [list $w $p1 $p2]
}

proc day22::part2 {input} {
    set 2nl [string first "\n\n" $input]
    set p1 [list {*}[string range $input [string first "\n" $input] $2nl]]
    set p2 [list {*}[string range $input [string first "\n" $input $2nl+2] end]]

    lassign [round $p1 $p2] winner p1Deck p2Deck
    return [deckScore $winner]
}
e.g. {day22::part2 $test} -> 291
