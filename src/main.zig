const exit = @import("./syscalls.zig").exit;
const printnf = @import("./myprint.zig").printer.printnf;
const printf = @import("./myprint.zig").printer.printf;

export fn _start() usize {
    main();
    return exit(0);
}

pub fn main() void {
    printnf("Hey how are you\n");
    printnf("Hey not bad, what about you?\n");
    printf("What is up {}\n {} {}", .{ "hellow", "some long thing but shoudl be ok", "blalalalalalala" });

    const hey = "A" ** 4098;
    printnf(hey);
}
