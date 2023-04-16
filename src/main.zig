const multiboot = @import("./booters/multiboot.zig");

export var _ align(4) linksection(".multiboot") = multiboot.multiboot_1_header;

export fn _start() align(4) linksection(".text") callconv(.Naked) noreturn {
     asm volatile (
        \\mov $0x1000000, %esp
        \\push %ebx 
        \\push %eax  
        \\call kmain  
        \\cli
        \\hlt
    );

    while (true) {}

}
 
 
export fn kmain() void {
}