# v-os-barebones
Simple code to get V to run under a freestanding operating system kernel. Code snippets taken from vinix.

Uses the limine bootloader, follow their steps to allow limine to compile alongside the kernel.

```sh
make      # make V kernel
make qemu # run qemu
```
