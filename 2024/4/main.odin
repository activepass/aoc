package main

import "core:slice"
import "core:strings"
import "core:fmt"


main :: proc() {
    data := #load("input", string)
    p1 := part1(data)
    p2 := part2(data)

    fmt.println(p1, p2)
    assert(p1 == 2560)
    assert(p2 == 1910)
}

Direction :: enum {
	N,
	E,
	S,
	W,
	NE,
	SE,
	SW,
	NW,
}

Dir_vec := [Direction][2]int {
	.N  = {0, -1},
	.NE = {1, -1},
	.E  = {1, 0},
	.SE = {1, 1},
	.S  = {0, 1},
	.SW = {-1, 1},
	.W  = {-1, 0},
	.NW = {-1, -1},
}

// assume input data is square (it is)
get_grid_length :: proc(s: string) -> (length: int) {
    for c in s {
        if c == '\n' do return
        length += 1
    }

    return
}

flatten_pos :: proc(pos: [2]int, grid_len: int) -> int {
    return grid_len * pos.y + pos.x + pos.y
}

valid_pos :: proc(pos: [2]int, grid_len: int) -> bool {
    return pos.x >= 0 && pos.y >= 0 && pos.x < grid_len && pos.y < grid_len
}

part1 :: proc(s: string) -> (count: int) {
    grid_len := get_grid_length(s)
    word := "XMAS"

    for y in 0..<grid_len {
        for x in 0..<grid_len {
            pos := [2]int{x, y}
            if s[flatten_pos(pos, grid_len)] != word[0] do continue

            dir_loop: for dir in Direction {
                new_pos := pos + Dir_vec[dir]
                wc : int
                for i in 1..<len(word) {
                    c := word[i]
                    if !valid_pos(new_pos, grid_len) do continue dir_loop
                    if s[flatten_pos(new_pos, grid_len)] != c do continue dir_loop
                    new_pos += Dir_vec[dir]
                }

                count += 1
            }
        }
    }

    return 
}

part2 :: proc(s: string) -> (count: int) {
    grid_len := get_grid_length(s)

    for y in 0..<grid_len {
        for x in 0..<grid_len {
            if s[flatten_pos({x, y}, grid_len)] != 'A' do continue
            if !valid_pos({x, y} + Dir_vec[.NE], grid_len) || !valid_pos({x, y} + Dir_vec[.SE], grid_len) || !valid_pos({x, y} + Dir_vec[.SW], grid_len) || !valid_pos({x, y} + Dir_vec[.NW], grid_len) do continue
            c : int

            if s[flatten_pos({x, y} + Dir_vec[.NE], grid_len)] == 'M' && s[flatten_pos({x, y} + Dir_vec[.SW], grid_len)] == 'S' do c += 1
            if s[flatten_pos({x, y} + Dir_vec[.NE], grid_len)] == 'S' && s[flatten_pos({x, y} + Dir_vec[.SW], grid_len)] == 'M' do c += 1
            if s[flatten_pos({x, y} + Dir_vec[.NW], grid_len)] == 'M' && s[flatten_pos({x, y} + Dir_vec[.SE], grid_len)] == 'S' do c += 1                     
            if s[flatten_pos({x, y} + Dir_vec[.NW], grid_len)] == 'S' && s[flatten_pos({x, y} + Dir_vec[.SE], grid_len)] == 'M' do c += 1
            
            if c == 2 do count += 1
        }
    }

    return
}