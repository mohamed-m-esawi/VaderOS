.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM,   -(MAGIC + FLAGS)

.section .multiboot,"a"
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bootstrap.bss,"aw",@nobits
.align 16
stack_bottom:
.skip 16384
stack_top:

.section .bootstrap.text
.global _start
.type _start, @function
_start:
   mov $stack_top, %esp

   call paging_init

   mov $page_directory, %eax
   mov %eax, %cr3

   mov %cr0, %eax
   or $0x80000000, %eax
   mov %eax, %cr0

   // switch the stack to its higher-half alise.
   add $0xC0000000, %esp

   // continue excution at the high virtual address
   mov $higher_half_entry, %eax
   jmp *%eax

.size _start, . - _start

.section .text
.global higher_half_entry
higher_half_entry:
  call kernel_main

1:
  cli
  hlt
  jmp 1b
