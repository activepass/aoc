package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

atou :: proc(s: string) -> uint {
    v, _ := strconv.parse_uint(s)
    return v
}

main :: proc() {
    data := #load("input", string)

    p1 := part1(data)
    p2 := part2(data)
    fmt.println(p1, p2)

    assert(p1 == 6231007345478)
    assert(p2 == 333027885676693)
}

solvable :: proc(nums: []uint, expect, current_total: uint) -> bool {
    if len(nums) == 0 do return expect == current_total
    return solvable(nums[1:], expect, current_total * nums[0]) || solvable(nums[1:], expect, current_total + nums[0]) 
}

part1 :: proc(data: string) -> (sum: uint) {
    data := data
    for l in strings.split_lines_iterator(&data) {
        eq_str, _, num_str := strings.partition(l, ": ")
        total := atou(eq_str)
        numbers := slice.mapper(strings.split(num_str, " "), atou)

        if solvable(numbers[1:], total, numbers[0]) do sum += total 
    }
    return
}

// credit: laytan / odin discord
concat :: proc(a, b: uint) -> uint {
    d := a
    for c := b; c > 0; c /= 10 {
        d *= 10
    }
    return d + b
}

p2_solvable :: proc(nums: []uint, expect, current_total: uint) -> bool {
    if len(nums) == 0 do return expect == current_total
    return p2_solvable(nums[1:], expect, current_total * nums[0]) || p2_solvable(nums[1:], expect, current_total + nums[0]) || p2_solvable(nums[1:], expect, concat(current_total, nums[0]))
}

part2 :: proc(data: string) -> (sum: uint) {
    data := data
    for l in strings.split_lines_iterator(&data) {
        eq_str, _, num_str := strings.partition(l, ": ")
        total := atou(eq_str)
        numbers := slice.mapper(strings.split(num_str, " "), atou)

        if p2_solvable(numbers[1:], total, numbers[0]) do sum += total 
    }
    return
}