package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

f_str, f_copy : string

main :: proc() {
    f_str = #load("input", string)
    f_copy = f_str
    
    fmt.printfln("part1 -> %d", part1())
    fmt.printfln("part2 -> %d", part2())
}

part1 :: proc() -> int {
    ll, rl : [dynamic]int = {}, {}
    defer delete(ll)
    defer delete(rl)

    for line in strings.split_lines_iterator(&f_copy) {
        parts := strings.split(line, "   ")
        lv, _ := strconv.parse_int(parts[0], 10)
        rv, _ := strconv.parse_int(parts[1], 10)
        append(&ll, lv)
        append(&rl, rv)
    }

    slice.sort(ll[:])
    slice.sort(rl[:])

    sum := 0
    for v, i in ll {
        sum += abs(v - rl[i])
    }

    return sum
}

part2:: proc() -> int {
    ll, rl : [dynamic]int = {}, {}
    defer delete(ll)
    defer delete(rl)
    similarity := make(map[int]int)
    defer delete(similarity)

    for line in strings.split_lines_iterator(&f_str) {
        parts := strings.split(line, "   ")
        lv, _ := strconv.parse_int(parts[0], 10)
        rv, _ := strconv.parse_int(parts[1], 10)
        append(&ll, lv)
        append(&rl, rv)
        similarity[rv] += 1
    }

    slice.sort(ll[:])
    slice.sort(rl[:])

    sim_count := 0
    for v in ll {
        sim_count += v * similarity[v]
    }

    return sim_count
}