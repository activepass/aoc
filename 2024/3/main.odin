package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/regex"

main :: proc() {
    data := #load("input", string)

    p1 := part1(data)
    p2 := part2(data)

    fmt.println(p1, p2)
    assert(p1 == 167650499)
    assert(p2 == 95846796)
}

part1 :: proc(data: string) -> int {
    i := 0
    sum := 0
    enabled := true
    re, e := regex.create(`mul\(([0-9]*),([0-9]*)\)`, {.Global})
    if e != nil do panic("regex err")

    for {
        c, ok := regex.match(re, data[i:])
        defer regex.destroy_capture(c)
        if !ok do break
        
        i += c.pos[0][1]
        sum += strconv.atoi(c.groups[1]) * strconv.atoi(c.groups[2])

    }

    return sum
}

part2 :: proc(data: string) -> int {
    i := 0
    sum := 0
    enabled := true

    re, e := regex.create(`mul\(([0-9]*),([0-9]*)\)|do\(\)|don't\(\)`, {.Global})
    if e != nil do panic("regex err")

    for {
        c, ok := regex.match(re, data[i:])
        defer regex.destroy_capture(c)
        if !ok do break
        
        i += c.pos[0][1]
        switch c.groups[0] {
            case "do()":
                enabled = true
            case "don't()":
                enabled = false
            case:
                if !enabled do continue
                sum += strconv.atoi(c.groups[1]) * strconv.atoi(c.groups[2])
        } 
    }

    return sum
}