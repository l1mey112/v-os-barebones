# Convenience macro to reliably declare overridable command variables.
define DEFAULT_VAR =
	ifeq ($(origin $1), default)
		override $(1) := $(2)
	endif
	ifeq ($(origin $1), undefined)
		override $(1) := $(2)
	endif
endef

$(eval $(call DEFAULT_VAR,CC,cc))

override VFILES := $(shell find ./ -type f -name '*.v')
override CFILES := $(shell find ./ -type f -name '*.c' ! -path './limine*' ! -name 'blob.c')

override ISO_NAME := image.iso
override ELF_NAME := os.elf

override BUILD_PATH := build
override KERNEL := build/$(ELF_NAME)
override ISO := build/$(ISO_NAME)

override INTERNALCFLAGS := \
		-O0							       \
		-std=gnu99					       \
		-nostdlib 					       \
		-nostdinc					       \
		-ffreestanding				       \
		-fno-omit-frame-pointer            \
		-fno-stack-protector               \
		-fno-stack-check                   \
		-fno-pic                           \
		-fno-pie                           \
		-ffunction-sections                \
		-fdata-sections                    \
		-fno-strict-aliasing               \
		-mabi=sysv                         \
		-mno-80387                         \
		-mno-mmx                           \
		-mno-3dnow                         \
		-mno-sse                           \
		-mno-sse2                          \
		-mno-red-zone                      \
		-Wno-address-of-packed-member      \
		-Wno-unused-value                  \
		-Wno-unused-label                  \
		-Wno-unused-function               \
		-Wno-unused-variable               \
		-Wno-unused-parameter		       \
		-Isrc/freestanding_headers         \
		-Isrc/c -Isrc/c/sys                \
		-mcmodel=kernel                    \
		-MMD                               \
		-ggdb

override INTERNALVFLAGS := \
	-enable-globals \
	-nofloat		\
	-gc none        \
	-g              \
	-d no_backtrace \
	-autofree       \
	-d no_main

# Internal linker flags that should not be changed by the user.
override INTERNALLDFLAGS :=     \
	-nostdlib                   \
	-static                     \
	-Wl,-z,max-page-size=0x1000 \
	-Wl,-T,linker.ld

# Default target.
.PHONY: all
all: build limine/ $(ISO)

$(ISO): $(KERNEL) limine.cfg limine/
	cp -v limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin build
	echo -e "\n\n# INSERTED BY MAKEFILE\nKERNEL_PATH=boot:///$(ELF_NAME)" >> build/limine.cfg
	
ifneq ("$(wildcard $(ISO))","")
	rm $(ISO)
endif

	cd build && xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		. -o $(ISO_NAME)
	
	./limine/limine-deploy $(ISO)

build:
	mkdir build

limine/:
#	git clone https://github.com/limine-bootloader/limine.git --branch=v3.0-branch-binary --depth=1
#	For some reason, older versions of limine work. but newer versions do not?
#	I have copied an older version of the source tree used in a old project here.
	make -C limine

$(KERNEL): $(CFILES) $(VFILES) src src/freestanding_headers
	v $(INTERNALVFLAGS) src -o build/blob.c
	$(CC) $(INTERNALCFLAGS) -w -c build/blob.c $(CFILES) -o build/kernel.o
	$(CC) build/kernel.o $(LDFLAGS) $(INTERNALLDFLAGS) -o $(KERNEL)

# Remove object files and the final executable.
.PHONY: clean
clean:
	rm -rf $(KERNEL) $(OBJ) $(HEADER_DEPS) build

.PHONY: qemu
qemu: all
	qemu-system-x86_64 $(ISO)