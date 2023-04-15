ENTRY(_start)
 
SECTIONS {
    . = 1M;
	KERNEL_PHYSADDR_START = .;

     .multiboot : ALIGN(4K) {
        KEEP(*(.multiboot .multiboot.*))
    }
 
    .text : ALIGN(4K) {
        *(.text)
    }
 
    .rodata : ALIGN(4K) {
        *(.rodata)
    }
 
    .data : ALIGN(4K) {
        *(.data)
    }
 
    .bss : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}