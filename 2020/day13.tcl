package require aoc

namespace eval day13 {
    namespace export part1 part2
}

set test "939
7,13,x,x,59,x,31,19"

proc day13::part1 {input} {
    lassign [aoc::nonEmptyLines $input] t0 buses0
    set buses [dict create]
    foreach id [split $buses0 ","] {
        if {$id == "x"} {continue}
        dict set buses $id [expr {$id - ($t0 % $id)}]
    }
    set nextDeparture [tcl::mathfunc::min {*}[dict values $buses]]
    dict for {id departsIn} $buses {
        if {$departsIn == $nextDeparture} {
            return [expr {$id * $departsIn}]
        }
    }
}
e.g. {day13::part1 $test} -> 295

# I didn't know about CRT before attempting this.
# Someday I might try to refactor this using CRT.
# Until then, here's an explanation:

# Optimization 1: Don't check every time.
# If bus i leaves at time t, and bus j leaves at time t+1, the next time this
# happens is at time t + lcm(i,j).
#
# Unfortunately, while counting up in steps of lcm(i,j) works for small inputs,
# it will not solve the puzzle input in a reasonable time.

# Optimization 2: Calculate the number to multiply lcm(i,j) by in order to
# arrive at the time t such that which bus k leaves at time t+3
# (assuming the input is "i,j,k")
#
# Let t be the time at which bus i leaves, and t+1 be the time bus j leaves.
# We wish to find a value for t2 such that bus i leaves at t2, bus j leaves at
# t2+1, and bus k leaves at time t2+2, given the above input.
#
# Every time lcm(i,j) is added to t, (t % k) moves by (lcm(i,j) % k). This is
# called a step. Instead of adding lcm(i,j) repeatedly until the right t2 is
# found, the number of steps can be calculated by first calculating the 'shift'
# in the ring of k numbers in (x % k) after moving by ceil(k / $step) steps.
# A loop can be used to find a value in [0,k) that is c*$shift steps away from
# the desired value (2, in this case, but depends on the number of 'x' busses).
# Suppose such a value is found after b steps. Adding the product of lcm(i,j)
# and (b*ceil(k / $step) + c) to t gives t2.
proc day13::LcmCoefficient {t i lcm bus} {
    set start [expr {$t % $bus}]
    set want [expr {$bus - $i}]
    set step [expr {$lcm % $bus}]
    set stepsPerCycle [expr {int(ceil($bus/$step))}]
    set shift [expr {($step * $stepsPerCycle) % $bus}]
    set a $start
    set steps 0
    while {($want - $a) % $shift != 0} {
        set a [expr {($a + $step) % $bus}]
        incr steps
    }
    set cycles [expr {($want - $a) / $shift}]
    set res [expr {($cycles * $stepsPerCycle) + $steps}]
    return $res
}
e.g. {day13::LcmCoefficient 1789 1 1789 37} -> 16
e.g. {day13::LcmCoefficient 30413 2 66193 47} -> 19
e.g. {day13::LcmCoefficient 1288080 3 3111071 1889} -> 386

proc day13::part2 {input} {
    set buses [split [lindex $input 1] ","]
    set t [lindex $buses 0]
    set lcm [lindex $buses 0]
    for {set i 1} {$i < [llength $buses]} {incr i 1} {
        set bus [lindex $buses $i]
        if {$bus == "x"} {continue}
        set coeff [LcmCoefficient $t $i $lcm $bus]
        incr t [expr {$lcm * $coeff}]
        set lcm [expr {$lcm * $bus}]
    }
    return $t
}
e.g. {day13::part2 $test} -> 1068781
e.g. {day13::part2 "0\n17,x,13,19"} -> 3417
e.g. {day13::part2 "0\n67,7,59,61"} -> 754018
e.g. {day13::part2 "0\n67,x,7,59,61"} -> 779210
e.g. {day13::part2 "0\n67,7,x,59,61"} -> 1261476
e.g. {day13::part2 "0\n1789,37,47,1889"} -> 1202161486
