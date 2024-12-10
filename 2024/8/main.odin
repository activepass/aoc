package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

GRID_SIZE :: 50
Position :: [2]int

valid_pos :: proc(p: Position) -> bool {
	return p.x >= 0 && p.y >= 0 && p.x < GRID_SIZE && p.y < GRID_SIZE
}

main :: proc() {
	data := #load("input", string)
	p1 := part1(data)
	p2 := part2(data)

	fmt.println(p1, p2)
	assert(p1 == 400)
	assert(p2 == 1280)
}

draw_antinodes :: proc(an: map[Position]struct{}) {
	for y in 0..<GRID_SIZE {
		line : [GRID_SIZE]rune
		for x in 0..<GRID_SIZE {
			p := Position{x, y}
			if p in an {
				line[x] = '#'
			} else {
				line[x] = '.'
			}
			
		}
		fmt.printfln("%s", line)
	}
	fmt.println()
}

part1 :: proc(s: string) -> int {
	s := s
	antinodes : map[Position]struct{}

	grid : map[rune][dynamic]Position
	y := 0
	for l in strings.split_lines_iterator(&s) {
		defer y += 1
		for c, x in l {
			if c == '.' do continue
			pos : Position = {x, y}
			if c in grid {
				for res_node in grid[c] {
					diff := pos - res_node
					an_1 := pos + diff
					an_2 := res_node - diff
					if valid_pos(an_1) do antinodes[an_1] = {}
					if valid_pos(an_2) do antinodes[an_2] = {}
				}
				append(&grid[c], pos)
			} else {
				grid[c] = {}
				append(&grid[c], pos)
			}
		}
	}
	
	return len(antinodes)
}



part2 :: proc(s: string) -> int{
	s := s
	antinodes : map[Position]struct{}

	grid : map[rune][dynamic]Position
	y := 0
	for l in strings.split_lines_iterator(&s) {
		defer y += 1
		for c, x in l {
			if c == '.' do continue
			pos : Position = {x, y}
			if c in grid {
				antinodes[pos] = {}
				for res_node in grid[c] {
					antinodes[res_node] = {}
					diff := pos - res_node
					self_dir_node := pos + diff
					res_dir_node := res_node - diff
					for valid_pos(self_dir_node) {
						antinodes[self_dir_node] = {}
						self_dir_node += diff
					}
					for valid_pos(res_dir_node) {
						antinodes[res_dir_node] = {}
						res_dir_node -= diff
					}
				}
				append(&grid[c], pos)
			} else {
				grid[c] = {}
				append(&grid[c], pos)
			}
		}
	}

	

	return len(antinodes)
}