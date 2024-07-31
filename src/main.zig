const exit = @import("./syscalls.zig").exit;
const printnf = @import("./myprint.zig").printer.printnf;
const print = @import("./myprint.zig").printer.printf;

export fn _start() usize {
    main();
    return exit(0);
}

pub fn main() void {
    printnf("Hey how are you\n");
    printnf("Hey not bad, what about you?\n");
}
