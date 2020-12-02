package require tcltest
namespace import ::tcltest::*

namespace eval day01 {

proc part1 {input} {
    foreach a $input {
        foreach b $input {
            if {$a + $b == 2020} {
                return [expr {$a * $b}]
            }
        }
    }
}

proc part2 {input} {
    foreach a $input {
        foreach b $input {
            foreach c $input {
                if {$a + $b + $c == 2020} {
                    return [expr {$a * $b * $c}]
                }
            }
        }
    }
}

test 1_1 {} -body {part1 [list 1721 979 366 299 675 1456]} -result 514579
test 2_1 {} -body {part2 [list 1721 979 366 299 675 1456]} -result 241861950
}
