const std = @import("std");
const Builder = @import("std").build.Builder;
const Target = @import("std").Target;
const CrossTarget = @import("std").zig.CrossTarget;
const Feature = @import("std").Target.Cpu.Feature;


fn example() void {

}

pub fn build(b: *Builder) !void {
    // Get build arguments
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const stdin = std.io.getStdIn();

    std.debug.print("Build options: \n - [0]: BIOS + Grub\n - [1]: BIOS + Limine\n - [2]: UEFI + Grub\n - [3]: UEFI + Limine\n" , .{});
    std.debug.print("Please enter a number: " , .{});
    var build_option_input = try stdin.reader().readUntilDelimiterAlloc(allocator, '\n', 1024);
    defer allocator.free(build_option_input);
    const features = Target.x86.Feature;


    var build_option = try std.fmt.parseInt(usize, build_option_input, 10);
    
 
    var disabled_features = Feature.Set.empty;
    var enabled_features = Feature.Set.empty;
 
    disabled_features.addFeature(@enumToInt(features.mmx));
    disabled_features.addFeature(@enumToInt(features.sse));
    disabled_features.addFeature(@enumToInt(features.sse2));
    disabled_features.addFeature(@enumToInt(features.avx));
    disabled_features.addFeature(@enumToInt(features.avx2));
    enabled_features.addFeature(@enumToInt(features.soft_float));
 
    const target = CrossTarget{
        .cpu_arch = Target.Cpu.Arch.i386,
        .os_tag = Target.Os.Tag.freestanding,
        .abi = Target.Abi.none,
        .cpu_features_sub = disabled_features,
        .cpu_features_add = enabled_features
    };
 
    const mode = b.standardReleaseOptions();
    
    const kernel = b.addExecutable("kernel.elf", "src/main.zig");

    // kernel.addAssemblyFile("src/_start.s");
    kernel.setTarget(target);
    kernel.setBuildMode(mode);
    kernel.setLinkerScriptPath(.{ .path = "src/linker.ld" });
    kernel.code_model = .kernel;
    kernel.install();
 
    const kernel_step = b.step("kernel", "Build the kernel");
    kernel_step.dependOn(&kernel.install_step.?.step);
 
    const iso_dir = b.fmt("{s}/iso_root", .{b.cache_root});
    const iso_dir_boot = b.fmt("{s}/iso_root/boot", .{b.cache_root});
    const iso_dir_boot_grub = b.fmt("{s}/iso_root/boot/grub", .{b.cache_root});
    const kernel_path = b.getInstallPath(kernel.install_step.?.dest_dir, kernel.out_filename);
    const iso_path = b.fmt("{s}/disk.iso", .{b.exe_dir});
 
    const iso_cmd_str = &[_][]const u8{ 
        "/bin/sh", "-c",
        std.mem.concat(b.allocator, u8, &[_][]const u8{
            "mkdir -p ", iso_dir_boot_grub, " && ",
            "cp ", kernel_path, " ", iso_dir_boot, " && ",
            "cp src/booters/grub/grub.cfg ", iso_dir_boot_grub, " && ",
            "grub-mkrescue -o ", iso_path, " ", iso_dir
        }) catch unreachable
    };
 
    const iso_cmd = b.addSystemCommand(iso_cmd_str);
    iso_cmd.step.dependOn(kernel_step);
 
    const iso_step = b.step("iso", "Build an ISO image");
    iso_step.dependOn(&iso_cmd.step);
    b.default_step.dependOn(iso_step);

    switch (build_option) {
        0 => {
           // BIOS + GRUB
             const run_cmd_str = &[_][]const u8{
                "qemu-system-x86_64",
                "-cdrom", iso_path,
                "-debugcon", "stdio",
                "-vga", "virtio",
                "-m", "4G",
                // "-machine", "q35,accel=kvm:whpx:tcg",
                "-no-reboot", "-no-shutdown"
            };

            const run_cmd = b.addSystemCommand(run_cmd_str);
            run_cmd.step.dependOn(b.getInstallStep());

            const run_step = b.step("run", "Run the kernel");
            run_step.dependOn(&run_cmd.step);

        },
        1 => {
            @panic("Not implmented yet");
        },
        2 => {
            // UEFI + GRUB
             const run_cmd_str = &[_][]const u8{
                "qemu-system-x86_64",
                "-bios", "./OVMF.fd",
                "-cdrom", iso_path,
                "-debugcon", "stdio",
                "-vga", "virtio",
                "-m", "4G",
                // "-machine", "q35,accel=kvm:whpx:tcg",
                "-no-reboot", "-no-shutdown"
            };

            const run_cmd = b.addSystemCommand(run_cmd_str);
            run_cmd.step.dependOn(b.getInstallStep());

            const run_step = b.step("run", "Run the kernel");
            run_step.dependOn(&run_cmd.step);
            },
        3 => {
            @panic("Not implmented yet");
            },
        else => { 
            @panic("Invaild build option");
        }
    }

 
 
}