# --- Toolchain --------------------------------------------------------------

CROSS ?= i686-elf-
CC    := $(CROSS)gcc
AS    := $(CROSS)as
QEMU  ?= qemu-system-i386

# --- Files ------------------------------------------------------------------

KERNEL  := vaderos.elf
OBJECTS := boot.o kernel.o
LINKER  := linker.ld

# --- Flags ------------------------------------------------------------------

WARNINGS  := -Wall -Wextra
FREESTAND := -ffreestanding -nostdlib
# No SSE/MMX/x87: they are not usable at boot
NO_SIMD   := -march=i686 -mgeneral-regs-only

CFLAGS  := -std=gnu99 -O2 $(WARNINGS) $(FREESTAND) $(NO_SIMD)
LDFLAGS := -T $(LINKER) -O2 $(FREESTAND)

# --- Build ------------------------------------------------------------------

.PHONY: all run debug clean

all: $(KERNEL)

$(KERNEL): $(OBJECTS) $(LINKER)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS) -lgcc

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $< -o $@

# --- Run --------------------------------------------------------------------

run: $(KERNEL)
	$(QEMU) -kernel $(KERNEL)

debug: $(KERNEL)
	$(QEMU) -kernel $(KERNEL) -no-reboot -no-shutdown -d int,cpu_reset -D qemu.log

clean:
	rm -f $(OBJECTS) $(KERNEL) qemu.log
