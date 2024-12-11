package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

GRID_SIZE :: 50

Position :: [2]int

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

rtoi :: #force_inline proc(c: rune) -> int {
	return int(c - '0')
}

valid_pos :: proc(p: Position) -> bool {
	return p.x >= 0 && p.y >= 0 && p.x < GRID_SIZE && p.y < GRID_SIZE
}

main :: proc() {
	data := #load("input", string)
	p1 := part1(data)
	p2 := part2(data)

	fmt.println(p1, p2)
	assert(p1 == 611)
	assert(p2 == 1380)
}

count_trails :: proc(
	grid: [GRID_SIZE][GRID_SIZE]int,
	pos: Position,
	height: int,
) -> (
	trails: int,
) {
	if height == 9 {
		return 1
	}

	for dir in Direction {
		next_pos := pos + Dir_vec[dir]
		if !valid_pos(next_pos) do continue
		if grid[next_pos.y][next_pos.x] != height + 1 do continue

		trails += count_trails(grid, next_pos, height + 1)
	}

	return
}

p1_count_trails :: proc(
	grid: [GRID_SIZE][GRID_SIZE]int,
	pos: Position,
	height: int,
	found: ^map[Position]struct {},
) -> (
	trails: int,
) {
	if height == 9 {
		if pos in found do return 0
		found[pos] = {}
		return 1
	}

	for dir in Direction {
		next_pos := pos + Dir_vec[dir]
		if !valid_pos(next_pos) do continue
		if grid[next_pos.y][next_pos.x] != height + 1 do continue

		trails += p1_count_trails(grid, next_pos, height + 1, found)
	}

	return
}

part1 :: proc(s: string) -> (sum: int) {
	s := s
	grid: [GRID_SIZE][GRID_SIZE]int
	trailheads: [dynamic]Position

	y := 0
	for l in strings.split_lines_iterator(&s) {
		defer y += 1
		for c, x in l {
			height := rtoi(c)
			if height == 0 do append(&trailheads, Position{x, y})
			grid[y][x] = height
		}
	}

	found: map[Position]struct {}
	for t in trailheads {
		defer clear(&found)
		sum += p1_count_trails(grid, t, 0, &found)
	}

	return
}

part2 :: proc(s: string) -> (sum: int) {
	s := s
	grid: [GRID_SIZE][GRID_SIZE]int
	trailheads: [dynamic]Position

	y := 0
	for l in strings.split_lines_iterator(&s) {
		defer y += 1
		for c, x in l {
			height := rtoi(c)
			if height == 0 do append(&trailheads, Position{x, y})
			grid[y][x] = height
		}
	}

	for t in trailheads {
		sum += count_trails(grid, t, 0)
	}

	return
}
