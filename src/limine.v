// Code is governed by the GPL-2.0 license.
// Copyright (C) 2021-2022 The Vinix authors.

pub const (
	limine_memmap_usable                 = 0
	limine_memmap_reserved               = 1
	limine_memmap_acpi_reclaimable       = 2
	limine_memmap_acpi_nvs               = 3
	limine_memmap_bad_memory             = 4
	limine_memmap_bootloader_reclaimable = 5
	limine_memmap_kernel_and_modules     = 6
	limine_memmap_framebuffer            = 7
)

pub struct LimineMemmapEntry {
pub mut:
	base u64
	length u64
	@type u64
}

pub struct LimineMemmapResponse {
pub mut:
	revision u64
	entry_count u64
	entries &&LimineMemmapEntry
}

pub struct LimineMemmapRequest {
pub mut:
	id [4]u64 = [
		u64(0xc7b1dd30df4c8b88), 0x0a82e883a194f07b,
		0x67cf3d9d378a806f, 0xe304acdfc50c3c62
	]!
	revision u64
	response &LimineMemmapResponse
}

pub struct LimineTerminal {
pub mut:
	columns u32
	rows u32
	framebuffer voidptr // &LimineFramebuffer
}

pub struct LimineTerminalResponse {
pub mut:
	revision u64
	terminal_count u64
	terminals &&LimineTerminal
	write fn(&LimineTerminal, charptr, u64)
}

pub struct LimineTerminalRequest {
pub mut:
	id [4]u64 = [
		u64(0xc7b1dd30df4c8b88), 0x0a82e883a194f07b,
		0x0785a0aea5d0750f, 0x1c1936fee0d6cf6e
	]!
	revision u64
	response &LimineTerminalResponse
	callback fn(&LimineTerminal, u64, u64, u64, u64)
}