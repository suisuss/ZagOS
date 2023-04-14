# ZagOS

Bare bones hello world zig based OS

## Requirements:

- zig v0.10.1
- qemu-system-x86
- xorriso
- grub-mkrescue
- mtools
- probably other stuff


## Setup

Build:

```
zig build
```

Run:

```
zig build run
```

## Cavaets

1. VSCode overrides environment variable GTK_PATH and can interfere with QEMU, so may need to run:

```unset GTK_PATH ```

## Conclusion

- This was way easier than developing a bare bones with golang
- Zig is great
- GRUB is out of date