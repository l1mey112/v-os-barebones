# v-os-barebones
Simple code to get V to run as a freestanding operating system kernel. Code snippets taken from vinix.

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
