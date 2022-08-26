module main

// Code is governed by the GPL-2.0 license.
// Copyright (C) 2021-2022 The Vinix authors.

[export: 'memcpy']
pub fn memcpy(dest voidptr, src voidptr, size u64) voidptr {
	unsafe {
		mut destm := &u8(dest)
		srcm := &u8(src)

		for i := 0; i < size; i++ {
			destm[i] = srcm[i]
		}
	}
	return dest
}

[export: 'memset']
pub fn memset(dest voidptr, c int, size u64) voidptr {
	unsafe {
		mut destm := &u8(dest)

		for i := 0; i < size; i++ {
			destm[i] = u8(c)
		}
	}
	return dest
}

[export: 'memcmp']
pub fn memcmp(_s1 &C.void, _s2 &C.void, size u64) int {
	unsafe {
		s1 := &u8(_s1)
		s2 := &u8(_s2)

		for i := 0; i < size; i++ {
			if s1[i] != s2[i] {
				return if s1[i] < s2[i] { -1 } else { 1 }
			}
		}
	}
	return 0
}

[export: 'memmove']
pub fn memmove(dest &C.void, src &C.void, size u64) &C.void {
	unsafe {
		mut destm := &u8(dest)
		srcm := &u8(src)

		if src > dest {
			for i := 0; i < size; i++ {
				destm[i] = srcm[i]
			}
		} else if src < dest {
			for i := size; i > 0; i-- {
				destm[i - 1] = srcm[i - 1]
			}
		}

		return dest
	}
}