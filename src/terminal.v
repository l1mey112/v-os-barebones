module main

fn limine_term_callback(p &LimineTerminal, t u64, a u64, b u64, c u64) {
	return
}

[cinit]
__global (
	volatile term_request = LimineTerminalRequest{
		response: 0
		callback: &limine_term_callback
	}
)

__global (
	term_terminal = &LimineTerminal(0)
)

pub fn init_term(){
	if term_request.response == voidptr(0) || 
	   term_request.response.terminal_count < 1 
	{
		halt()
	}
	term_terminal = unsafe { term_request.response.terminals[0] }
	kprint(c'[term] initialised\n')
}

[export: 'write']
pub fn write(fd int, buf &C.void, count u64) i64 {
	if fd != 1 && fd != 2 && fd != 0 {
		term_request.response.write(term_terminal,c'write to fd != 0 to 2 is a stub\n',32)
	}
	term_request.response.write(term_terminal,charptr(buf),count)
	return i64(count)
}

[export: 'fwrite']
pub fn fwrite(ptr voidptr, size u64, nmemb u64, fd u64) u64 {
	if fd != 1 && fd != 2 && fd != 0 { // `&& fd != 0` for V reasons...
		term_request.response.write(term_terminal,c'fwrite to fd != 0 to 2 is a stub\n',33)
	}
	term_request.response.write(term_terminal,ptr,size*nmemb)
	return size*nmemb
}

[export: 'strlen']
pub fn strlen(_ptr &C.char) int {
	mut i := int(0)

	unsafe {
		ptr := &u8(voidptr(_ptr))
		for {
			if ptr[i] == 0 {
				break
			}

			i++
		}
	}
	return i
}

fn C.strlen (&u8) int

pub fn kprint(data &u8){
	term_request.response.write(term_terminal,data,u64(C.strlen(data)))
}

[noreturn]
pub fn kpanic(data &u8){
	kprint(c"kernel panic...\n")
	kprint(data)
	halt()
}