const console = @import("console.zig");
 
const ALIGN = 1 << 0; // 0000 0001 - one left shift zero
const MEMINFO = 1 << 1; // 0000 0010 - one left shift 1
const MAGIC = 0x1BADB002; // GRUB magic
const FLAGS = ALIGN | MEMINFO;
 
 // When using extern the C ABI reserves the bytes to allocate the struct. Use packed struct for more than 12 bytes
const MultibootHeader = extern struct {
    magic: i32 = MAGIC, // 32 bits = 4 bytes (4*8)
    flags: i32,
    checksum: i32,
};// 12 byte struct for header
 
export var multiboot align(4) linksection(".multiboot") = MultibootHeader{
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};


// _start and stack init is in asm stub

 
export fn kmain() void {
    console.initialize();
    console.puts("Hello world!");
}