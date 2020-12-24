package require aoc

namespace eval day24 {
    namespace export part1 part2
}

set test "sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
"

proc dxdy {dir} {
    return [switch $dir {
        e  {list  1  0}
        w  {list -1  0}
        ne {list  0  1}
        nw {list -1  1}
        se {list  1 -1}
        sw {list  0 -1}
    }]
}

proc parseLine {line} {
    set i 0
    set res {}
    while {$i < [string length $line]} {
        switch -glob -- [string range $line $i $i+1] {
            e* {incr i 1; lappend res e}
            w* {incr i 1; lappend res w}
            ne {incr i 2; lappend res ne}
            nw {incr i 2; lappend res nw}
            se {incr i 2; lappend res se}
            sw {incr i 2; lappend res sw}
        }
    }
    return $res
}

proc countBlack {tiles} {
    set count 0
    dict for {k v} $tiles {
        if {$v % 2 == 1} {incr count}
    }
    return $count
}

proc day24::part1 {input} {
    set flipped [dict create]
    foreach tile [aoc::nonEmptyLines $input] {
        set dirs [parseLine $tile]
        set dx 0
        set dy 0
        foreach dir $dirs {
            lassign [dxdy $dir] ddx ddy
            incr dx $ddx
            incr dy $ddy
        }
        set key [list $dx $dy]
        dict incr flipped $key
    }
    return [countBlack $flipped]
}
e.g. {day24::part1 $test} -> 10

proc neighbors {x y} {
    set res {}
    foreach dir {e se sw w nw ne} {
        lassign [dxdy $dir] dx dy
        lappend res [list [expr {$x + $dx}] [expr {$y + $dy}]]
    }
    return $res
}

proc nextDay {tiles} {
    # only store black tiles
    set tilesAndNeighbors $tiles
    dict for {xy v} $tiles {
        foreach neigh [neighbors {*}$xy] {
            if {![dict exists $tilesAndNeighbors $neigh]} {
                dict set tilesAndNeighbors $neigh 0
            }
        }
    }

    set next [dict create]
    dict for {xy isBlack} $tilesAndNeighbors {
        set ns [neighbors {*}$xy]
        set blackns [::tcl::mathop::+ {*}[lmap n $ns {dict exists $tiles $n}]]
        if {$isBlack} {
            if {$blackns == 0 || $blackns > 2} {
                continue
            } else {
                dict set next $xy 1
            }
        } elseif {!$isBlack && $blackns == 2} {
            dict set next $xy 1
        }
    }
    return $next
}


proc day24::part2 {input} {
    set tiles [dict create]
    foreach tile [aoc::nonEmptyLines $input] {
        set dirs [parseLine $tile]
        set dx 0
        set dy 0
        foreach dir $dirs {
            lassign [dxdy $dir] ddx ddy
            incr dx $ddx
            incr dy $ddy
        }
        set key [list $dx $dy]
        dict incr tiles $key
    }
    set tiles [dict filter $tiles script {xy v} {expr {$v % 2 == 1}}]
    set day 0
    while {$day < 100} {
        puts "day $day"
        set tiles [nextDay $tiles]
        puts [countBlack $tiles]
        incr day
    }
    return [countBlack $tiles]
}
e.g. {day24::part2 $test} -> 2208
