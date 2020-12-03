namespace eval day01 {
    namespace export part1 part2
}

proc day01::part1 {input} {
    foreach a $input {
        foreach b $input {
            if {$a + $b == 2020} {
                return [expr {$a * $b}]
            }
        }
    }
}
e.g. {day01::part1 [list 1721 979 366 299 675 1456]} -> 514579

proc day01::part2 {input} {
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
e.g. {day01::part2 [list 1721 979 366 299 675 1456]} -> 241861950
