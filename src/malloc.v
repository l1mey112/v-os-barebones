[cinit]
__global (
	volatile memory_req = LimineMemmapRequest{response: 0}
)

[cinit]
__global (
	memory_freetop  = u64(0)
	memory_freebase = u64(0)
	memory_map      = LimineMemmapEntry{}
)

pub fn init_memory() {
	resp := memory_req.response
	mut largest_block := LimineMemmapEntry{}
	unsafe {
		for i := 0; i < resp.entry_count; i++ {
			if  resp.entries[i].@type != u32(limine_memmap_usable)
				&&  resp.entries[i].@type != u32(limine_memmap_bootloader_reclaimable) {
				continue
			}
			if resp.entries[i].length > largest_block.length {
				largest_block = *resp.entries[i]
			}
		}
	}
	memory_freetop = largest_block.base + largest_block.length
	memory_freebase = largest_block.base
	memory_map = largest_block

	if memory_freebase == 0 || memory_freetop == 0 {
		kpanic(c"memory failed to initialise!")
	}

	kprint(c"[memory] initialised\n")
}

// This is a simple bump allocator, which will never free.

[export: 'malloc']
fn malloc_(size u64) voidptr {
    location := memory_freebase
    memory_freebase += size

    if memory_freebase > memory_freetop {
        kpanic(c"memory - out of data")
    }
    return voidptr(location)
}

[export: 'calloc']
pub fn calloc_(a u64, b u64) voidptr {
	sz := a * b
	ptr := unsafe { malloc(sz) }

	memset(ptr, 0, sz)
	return ptr
}

[export: 'realloc']
pub fn realloc_(a u64, b u64) voidptr {
	kpanic(c"stub - realloc called")
	return voidptr(0)
}

[export: 'free']
pub fn free_(ptr voidptr) {
	return
}
