const exit = @import("./arch/x86/syscalls.zig").exit;
const printf = @import("./io/print/print.zig").Printer.printf;

export fn _start() usize {
    main();
    return exit(0);
}

pub fn main() void {
    const thing = "qweqwe";
    const thing2 = "whataataddda";
    const arr: [2][:0]const u8 = .{ thing, thing2 };
    printf("{} {} {}\n", .{ 1234, "another", arr });
}
