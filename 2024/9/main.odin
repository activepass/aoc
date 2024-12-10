package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

rtoi :: #force_inline proc(c: rune) -> int {
	return int(c - '0')
}

main :: proc() {
	data := #load("input", string)
	p1 := part1(data)
	p2 := part2(data)
	fmt.println(p1, p2)

	assert(p1 == 6435922584968)
	assert(p2 == 6469636832766)
}

part1 :: proc(s: string) -> (checksum: int) {
	drive := make([dynamic]int)

	id := 0
	for c, i in s {
		count := rtoi(c)
		for x in 0 ..< count {
			append(&drive, i % 2 == 0 ? id : -1)
		}
		if i % 2 == 0 do id += 1
	}

	l := 0
	r := len(drive) - 1

	for l < r {
		if drive[l] != -1 do l += 1
		if drive[r] == -1 do r -= 1
		if drive[l] == -1 && r != -1 {
			slice.swap(drive[:], l, r)
		}
	}

	for x, i in drive {
		if x == -1 do break
		checksum += x * i
	}

	return
}

Space :: struct {
	val:    int,
	size:   int,
	offset: int,
}

part2 :: proc(s: string) -> (checksum: int) {
	files := make([dynamic]Space)
	free_space := make([dynamic]Space)

	id, offset: int
	for c, i in s {
		count := rtoi(c)
		if i % 2 == 0 {
			append(&files, Space{val = id, size = count, offset = offset})
			id += 1
		} else {
			append(&free_space, Space{val = -1, size = count, offset = offset})
		}
		offset += count
	}

	#reverse for &file in files {
		for &fs in free_space {
			if file.offset < fs.offset do continue
			if file.size > fs.size do continue

			file.offset = fs.offset
			fs.offset += file.size
			fs.size -= file.size
		}
	}

	for f in files {
		for i in f.offset ..< f.offset + f.size {
			checksum += f.val * i
		}
	}

	return
}
