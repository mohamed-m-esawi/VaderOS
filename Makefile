CC = i686-elf-gcc
AS = i686-elf-as

CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -ffreestanding -O2 -nostdlib

myos: boot.o kernel.o
	$(CC) $(LDFLAGS) -o $@ $^ -lgcc

boot.o: boot.s
	$(AS) $< -o $@

kernel.o: kernel.c
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: clean

clean:
	rm -f boot.o kernel.o myos

