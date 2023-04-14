.global _start
.type _start, @function

_start:
    mov $0x1000000, %esp  // stack

    push %ebx 
    push %eax  
    call kmain  

    cli
    hlt