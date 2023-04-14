ENTRY(_start)
 
SECTIONS {
    .multiboot :
        {
            KEEP(*(.multiboot .multiboot.*))
            . = ALIGN(4K);
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