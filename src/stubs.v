module main

[noreturn]
pub fn halt() {
    asm volatile amd64 {
		cli
	}
	for {
		asm volatile amd64 {
			hlt
		}
	}
	for {}
}

struct C.__file {}

type FILE = C.__file

[cinit]
__global (
	stdin  = &FILE(voidptr(0))
	stdout = &FILE(voidptr(0))
	stderr = &FILE(voidptr(0))
)

[export: 'getchar']
fn getchar() int {
	kpanic(c"stub - getchar called")
}

[export: 'getc']
fn getc(stream &FILE) int {
	kpanic(c"stub - getc called")
}

[export: 'qsort']
fn qsort(ptr voidptr, count u64, size u64, comp fn (a &C.void, b &C.void) int) {
	kpanic(c"stub - atexit called")
}

[export: 'atexit']
pub fn atexit(s voidptr){
	kpanic(c"stub - atexit called")
}

[export: 'fflush']
pub fn fflush(stream &FILE) int {
	return 0
}

[export: 'strerror']
pub fn strerror(code int)&u8{
	_ := code
	kpanic(c"stub - strerror called")
}


[export: 'exit'; noreturn]
pub fn kexit(code int) {
	_ := code
	kpanic(c"exit called inside kernel")
}
