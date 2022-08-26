module main

fn C._vinit(argc int, argv voidptr)

fn main(){
	kernel_entry()
}

fn kernel_entry() {
	defer { halt() }
	init_term()
	init_memory()

	C._vinit(0, 0)
	// V 'runtime' is enabled
	// strconv works and by extension, print and println

	println("\nHello World!\n")

	a := 10

	println("a := $a\n")

	mut b := []int{}
	b << 10
	b << 15
	b << 20

	println("c := $b")
	for idx, i in b {
		println("index $idx contains '$i'")
	}
}