package require aoc

namespace eval day21 {
    namespace export part1 part2
}

set test "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"

proc day21::intersect {a b} {
    return [lsort -unique [lmap v $a {expr {($v in $b) ? $v : [continue]}}]]
}

proc day21::difference {a b} {
    return [lsort -unique [lmap v $a {expr {($v ni $b) ? $v : [continue]}}]]
}

proc day21::part1 {input} {
    set suspects [dict create]
    set all [dict create]
    foreach l [aoc::nonEmptyLines $input] {
        regexp -- {(.*) \(contains (.*)\)} $l -> ingredients allergens
        set allergens [string map {, ""} $allergens]
        foreach ingredient $ingredients {dict incr all $ingredient}
        foreach allergen $allergens {
            if {![dict exists $suspects $allergen]} {
                dict set suspects $allergen $ingredients
            } else {
                set existing [dict get $suspects $allergen]
                dict set suspects $allergen [intersect $ingredients $existing]
            }
        }
    }
    set nonAllergens [dict remove $all {*}[concat {*}[dict values $suspects]]]
    set sum 0
    dict for {k v} $nonAllergens {incr sum $v}
    return $sum
}
e.g. {day21::part1 $test} -> 5

proc day21::part2 {input} {
    set suspects [dict create]
    foreach l [aoc::nonEmptyLines $input] {
        regexp -- {(.*) \(contains (.*)\)} $l -> ingredients allergens
        set allergens [string map {, ""} $allergens]
        foreach allergen $allergens {
            if {![dict exists $suspects $allergen]} {
                dict set suspects $allergen $ingredients
            } else {
                set existing [dict get $suspects $allergen]
                dict set suspects $allergen [intersect $ingredients $existing]
            }
        }
    }
    while 1 {
        set convicts [dict filter $suspects script {k v} {
            expr {[llength $v] == 1}
        }]
        set convictIngredients [dict values $convicts]
        set new [dict create]
        dict for {allergen convict} $convicts {
            dict for {k vs} $suspects {
                if {$k in [dict keys $convicts]} {continue}
                set vNew [difference $vs $convictIngredients]
                switch [llength $vNew] {
                    0       {continue}
                    1       {dict set convicts $k $vNew}
                    default {dict set new $k $vNew}
                }
            }
        }
        if {[dict size $new] == 0} {break}
        set suspects [dict merge $new $convicts]
    }
    set res [lmap a [lsort [dict keys $suspects]] {dict get $suspects $a}]
    return [join $res ,]
}
e.g. {day21::part2 $test} -> mxmxvkd,sqjhc,fvjkl
