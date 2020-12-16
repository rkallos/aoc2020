package require aoc

namespace eval day16 {
    namespace export part1 part2
}

set test "class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12"

proc day16::part1 {input} {
    set fields [string range $input 0 [string first \n\n $input]-1]
    set ranges {}
    foreach field [split $fields \n] {
        regexp -all -- {([0-9]+-[0-9]+) or ([0-9]+-[0-9]+)} $field -> startRange endRange
        lappend ranges $startRange $endRange
    }
    set tickets [string range $input [string first "nearby tickets:\n" $input]+16 end]
    set sum 0
    foreach ticket [split $tickets \n] {
        foreach value [split $ticket ,] {
            set valid 0
            foreach range $ranges {
                lassign [split $range -] start end
                if {$value >= $start && $value <= $end} {
                    set valid 1
                    break
                }
            }
            if {!$valid} {incr sum $value}
        }
    }
    return $sum
}
e.g. {day16::part1 $test} -> 71

set test2 "class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9"

proc day16::inRange {value ranges} {
    foreach range $ranges {
        lassign [split $range -] start end
        if {$value >= $start && $value <= $end} {
            return 1
        }
    }
    return 0
}

proc day16::columnInRange {values ranges} {
    foreach value $values {
        if {![inRange $value $ranges]} {
            return $value
        }
    }
    return 0
}

proc day16::part2 {input} {
    set fields [string range $input 0 [string first \n\n $input]-1]
    set fieldRanges [dict create]
    set re {^(.*): ([0-9]+-[0-9]+) or ([0-9]+-[0-9]+)}
    foreach field [split $fields \n] {
        regexp -all -- $re $field -> name startRange endRange
        dict lappend fieldRanges $name $startRange $endRange
    }

    set ticketsStart [string first "nearby tickets:\n" $input]+16
    set ticketsEnd end-1
    set tickets [string range $input $ticketsStart $ticketsEnd]

    set validTickets {}
    set allRanges [concat {*}[dict values $fieldRanges]]
    foreach ticket [split $tickets \n] {
        set values [split $ticket ,]
        set validValues 0
        foreach value $values {
            if {[inRange $value $allRanges]} {
                incr validValues
            }
        }
        if {$validValues != [llength $values]} {continue}
        lappend validTickets $values
    }

    set cols {}
    for {set i 0} {$i < [llength [lindex $validTickets 0]]} {incr i} {
        lappend cols [lmap t $validTickets {lindex $t $i}]
    }

    set candidates [dict create]
    for {set i 0} {$i < [llength $cols]} {incr i} {
        set col [lindex $cols $i]
        dict for {k v} $fieldRanges {
            set res [columnInRange $col $v]
            if {$res == 0} {
                dict lappend candidates $i $k
            }
        }
    }

    set mapping [dict create]
    while {[dict size $candidates] > 0} {
        dict for {k v} $candidates {
            if {[llength $v] == 1} {
                # only candidate for column. It must be so.
                dict set mapping $k [lindex $v 0]
            }
        }
        set newCandidates [dict create]
        dict for {k v} $candidates {
            foreach candidate $v {
                if {[lsearch -ascii $mapping $candidate] != -1} {
                    continue
                }
                dict lappend newCandidates $k $candidate
            }
        }
        set candidates $newCandidates
    }

    set myTicketStart [expr [string first "your ticket:\n" $input]+13]
    set myTicketEnd [expr [string first "\n" $input $myTicketStart]-1]
    set myTicket [split [string range $input $myTicketStart $myTicketEnd] ,]

    set columnsOfInterest [dict keys [dict filter $mapping value departure*]]
    set multiplicands2 [lmap c $columnsOfInterest {lindex $myTicket $c}]
    return [::tcl::mathop::* {*}$multiplicands2]
}

