package main

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:slice"

main :: proc() {
    data := #load("input", string)

    safe_reports := 0
    dampened_safe_reports := 0
    
    for report in strings.split_lines_iterator(&data) {
        levels := make([dynamic]int)
        defer delete(levels)

        s, _ := strings.split(report, " ")
        for level_str, i in s {
            append(&levels, strconv.atoi(level_str))
        }
        

        if safe(levels[:]) {
            safe_reports += 1
        } else if safe_dampened(levels[:]) {
            dampened_safe_reports += 1
        }
    }

    fmt.println(safe_reports, dampened_safe_reports, dampened_safe_reports+safe_reports)
    assert(safe_reports == 572)
    assert(dampened_safe_reports == 572 + 40)
}

safe :: proc(levels: []int) -> bool {
    desc := levels[0] > levels[1]

    for i in 0..<len(levels)-1 {
        diff := levels[i] - levels[i+1]
        if (desc && diff < 0) || (!desc && diff > 0) || (abs(diff) > 3) || (abs(diff) < 1) { 
            return false
        }
    }

    return true
}

safe_dampened :: proc(levels: []int) -> bool {
    for i in 0..<len(levels) {
        levels_copy := slice.clone_to_dynamic(levels)
        defer delete(levels_copy)

        ordered_remove(&levels_copy, i)
        if safe(levels_copy[:]) {
            return true
        }
    }


    return false
}