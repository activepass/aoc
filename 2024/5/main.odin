package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

Rule :: [2]int

Mode :: enum {
	Rule,
	Update,
}


main :: proc() {
	data := #load("input", string)

	rules: [dynamic]Rule
	vals: [dynamic]int
	mode: Mode = .Rule
	p1_count, p2_count: int
	for l in strings.split_lines_iterator(&data) {
		if l == "" {
			mode = .Update
			continue
		}
		switch mode {
		case .Rule:
			one, _, two := strings.partition(l, "|")
			append(&rules, Rule{strconv.atoi(one), strconv.atoi(two)})
		case .Update:
			vals := slice.mapper(strings.split(l, ","), strconv.atoi)
			fmt.println(vals)
			valid := check(rules[:], vals)
			fmt.println(valid)
			if valid do p1_count += vals[len(vals) / 2]
			else {
				sort(rules[:], vals)
				p2_count += vals[len(vals) / 2]
			}

		}

	}
	fmt.println(p1_count, p2_count)
	assert(p1_count == 5374)
	assert(p2_count == 4260)
}

slice_index :: proc(s: []int, val: int) -> (index: int) {
	for v, i in s {
		if v == val {
			return i
		}
	}
	return -1
}

check :: proc(rules: []Rule, vals: []int) -> (good: bool) {
	for r in rules {
		if slice.contains(vals, r.x) && slice.contains(vals, r.y) {
			idx := slice_index(vals, r.x)
			idy := slice_index(vals, r.y)
			if idx > idy {
				return
			}
		}
	}

	return true
}

sort :: proc(rules: []Rule, vals: []int) {
	needs_pass := true
	valc := vals

	for needs_pass {
		needs_pass = false
		for r in rules {
			idx := slice_index(valc, r.x)
			idy := slice_index(valc, r.y)
			if idx != -1 && idy != -1 && idx > idy {
				slice.swap(valc, idx, idy)
				needs_pass = true
			}
		}
	}
}
