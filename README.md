# v-os-barebones
Simple code to get V to run as a freestanding operating system kernel. Code snippets taken from vinix.

### Freestanding V

To use V functions that use some kind of dynamic memory allocation you would need to initialise a basic memory allocator and implemenations of malloc, free, calloc and (optional) realloc. Everything to do with strings (strconv), print and println, math functions and dynamic arrays all rely on malloc. To make things easier to implement the bare minimum, a very simple bump pointer/watermark allocator is implemented at the expense that memory will never be freed or reused.

Usually the `main__main` C function is the entry point to the V program. The entry point specified in the linker is `main__kernel_entry`. This allows initialisation done by V before the main function to be skipped and called ourselves. This is because it relies on a memory allocation that has to be set up beforehand. After the `_vinit` function is called and the V runtime is set up, the you are free to do anything V allows.

V printing functions also require `fwrite` and (in older versions of V) `write`. Ensure proper implementations of these. I use the limine terminal's printing capability and so does vinix.

### How to build

```sh
# install V from source, and run ./v symlink.
# install xorriso, check the makefile.

cd limine/ && make # create the limine-deploy executable
# Follow their steps if needed to allow limine to compile alongside the kernel.

make # make V kernel

# install qemu

make qemu # run qemu
```

![ssss](https://user-images.githubusercontent.com/66291634/186858460-371c3c95-bb38-413e-8a64-b3cd96cec01b.png)
