const ALIGN = 1 << 0; // 0000 0001 - one left shift zero
const MEMINFO = 1 << 1; // 0000 0010 - one left shift 1
const MULTIBOOT_1_MAGIC = 0x1BADB002; // GRUB magic
const MULTIBOOT_2_MAGIC = 0xE85250D6;
const FLAGS = ALIGN | MEMINFO;

 
 // When using extern the C ABI reserves the bytes to allocate the struct. Use packed struct for more than 12 bytes
const MultibootHeader = extern struct {
    magic: i32, // 32 bits = 4 bytes (4*8)
    flags: i32,
    checksum: i32,
};// 12 byte struct for header

pub const multiboot_1_header = MultibootHeader{
    .magic = MULTIBOOT_1_MAGIC,
    .flags = FLAGS,
    .checksum = -(MULTIBOOT_1_MAGIC + FLAGS),
};
 
 pub const multiboot_2_header = MultibootHeader{
    .magic = MULTIBOOT_2_MAGIC,
    .flags = FLAGS,
    .checksum = -(MULTIBOOT_2_MAGIC + FLAGS),
};
 