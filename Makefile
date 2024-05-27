# Makefile: the Make file.
# Copyleft GPL2.

# Toolchain
AS = nasm

# Assembler flags
ASFLAGS = \
	-f bin

# Image name
IMAGE_NAME = sectorOS.flp

all: build run

run:
	qemu-system-i386 -fda $(IMAGE_NAME) -boot a

build:
	touch $(IMAGE_NAME)
	nasm $(ASFLAGS) -o $(IMAGE_NAME) src/main.S

dis: build
	objdump -D -b binary -m i386 -Maddr16,data16 sectorOS.flp > sectorOS.disassembled
	@echo --- sectorOS.disassembled is ready