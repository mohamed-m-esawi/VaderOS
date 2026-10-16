ENTRY(_start)

KERNEL_OFFSET = 0xC0000000;
KERNEL_PHYS   = 0x00200000;

SECTIONS
{
  /* Low memory: GRUB starts execution here. */
  . = 0x00100000;

  .multiboot ALIGN(4) :
  {
    KEEP(*(.multiboot))
  }

  .bootstrap.text ALIGN(4K) :
  {
    *(.bootstrap.text)
  }

  .bootstrap.data ALIGN(4K) :
  {
    *(.bootstrap.data)
  }

  .bootstrap.bss ALIGN(4K) (NOLOAD) :
  {
    *(.bss.bootstrap)
    *(.bootstrap.bss)
  }

  /* High virtual addresses, physical load addresses remain low. */
  . = KERNEL_OFFSET + KERNEL_PHYS;

  .text ALIGN(4K) : AT(ADDR(.text) - KERNEL_OFFSET)
  {
    *(.text)
  }

  .rodata ALIGN(4K) : AT(ADDR(.rodata) - KERNEL_OFFSET)
  {
    *(.rodata)
  }

  .data ALIGN(4K) : AT(ADDR(.data) - KERNEL_OFFSET)
  {
    *(.data)
  }

  .bss ALIGN(4K) (NOLOAD) : AT(ADDR(.bss) - KERNEL_OFFSET)
  {
    *(COMMON)
    *(.bss)
  }
}

