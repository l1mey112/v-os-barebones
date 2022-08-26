# v-os-barebones
Simple code to get V to run under a freestanding operating system kernel. Code snippets taken from vinix.

Uses the limine bootloader, follow their steps to allow limine to compile alongside the kernel.

```sh
make      # make V kernel
make qemu # run qemu
```
![2022-08-26_18-14](https://user-images.githubusercontent.com/66291634/186856081-3c204464-769a-4ade-bbb3-106588300023.png)
