package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

GRID_SIZE :: 130

Direction :: enum {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

Dir_vec := [Direction][2]int {
	.UP    = {0, -1},
	.RIGHT = {1, 0},
	.DOWN  = {0, 1},
	.LEFT  = {-1, 0},
}

main :: proc() {
	data := #load("input", string)

	//     ----y----  ----x----  
	grid: [GRID_SIZE][GRID_SIZE]bool
	start_pos: [2]int

	y := 0
	for l in strings.split_lines_iterator(&data) {
		defer y += 1
		for s, i in l {
			if s == '#' {
				grid[y][i] = true
			} else if s == '^' {
				start_pos = [2]int{i, y}
			}
		}
	}

	p1 := part1(grid, start_pos)
	p2 := part2(grid, start_pos)

	fmt.println(p1, p2)
	assert(p1 == 5444)
	assert(p2 == 1946)
}

@(require_results)
rotate :: #force_inline proc(dir: Direction) -> Direction {
	return Direction((int(dir) + 1) % 4)
}

valid_pos :: proc(pos: [2]int) -> bool {
	return pos.x >= 0 && pos.y >= 0 && pos.x < GRID_SIZE && pos.y < GRID_SIZE
}

part1 :: proc(collisions: [GRID_SIZE][GRID_SIZE]bool, start_pos: [2]int) -> (count: int) {
	dir: Direction
	pos := start_pos
	history: [GRID_SIZE][GRID_SIZE]bool
	history[pos.y][pos.x] = true
	count = 1

	for {
		check_pos := pos + Dir_vec[dir]
		if !valid_pos(check_pos) do break
		if collisions[check_pos.y][check_pos.x] {
			dir = rotate(dir)
			continue
		}
		pos += Dir_vec[dir]
		if !history[pos.y][pos.x] {
			history[pos.y][pos.x] = true
			count += 1
		}
	}

	return
}

part2 :: proc(grid: [GRID_SIZE][GRID_SIZE]bool, start_pos: [2]int) -> (loops: int) {
	for obj_y in 0 ..< GRID_SIZE do for obj_x in 0 ..< GRID_SIZE {
		if start_pos == {obj_x, obj_y} do continue
		dir: Direction
		pos := start_pos

		grid := grid
		grid[obj_y][obj_x] = true

		// very cool trick from odin discord
		history: [Direction][GRID_SIZE][GRID_SIZE]bool
		history[dir][pos.y][pos.x] = true

		for {
			check_pos := pos + Dir_vec[dir]
			if !valid_pos(check_pos) do break
			if grid[check_pos.y][check_pos.x] {
				dir = rotate(dir)
				continue
			}
			pos += Dir_vec[dir]
			if history[dir][pos.y][pos.x] {
				loops += 1
				break
			}

			history[dir][pos.y][pos.x] = true
		}

	}

	return
}
