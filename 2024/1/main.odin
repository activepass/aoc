package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

f_str, f_copy: string

main :: proc() {
	f_str = #load("input", string)
	// f_copy = f_str

	p1, p2 := consolidated()
	fmt.printfln("part1 -> %d", p1)
	fmt.printfln("part2 -> %d", p2)
}

part1 :: proc() -> int {
	ll, rl: [dynamic]int = {}, {}
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

part2 :: proc() -> int {
	ll, rl: [dynamic]int = {}, {}
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

consolidated :: proc() -> (int, int) {
	ll, rl: [dynamic]int = {}, {}
	defer delete(ll)
	defer delete(rl)
	similarity := make(map[int]int)
	defer delete(similarity)
	
	GAP_SIZE :: 3
	NUM_SIZE :: 5

	for line in strings.split_lines_iterator(&f_str) {
		lv, _ := strconv.parse_int(line)
		rv, _ := strconv.parse_int(line[GAP_SIZE + NUM_SIZE:])
		append(&ll, lv)
		append(&rl, rv)
		similarity[rv] += 1
	}

	slice.sort(ll[:])
	slice.sort(rl[:])

	sim_count, sum := 0, 0
	for v, i in ll {
		sim_count += v * similarity[v]
		sum += abs(v - rl[i])
	}

	return sum, sim_count
}
