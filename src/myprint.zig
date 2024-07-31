const write = @import("./syscalls.zig").write;
const expect = @import("./utils.zig").compile_asserts.expect;
const usizeToString = @import("./utils.zig").compile_error_utils.usizeToString;

pub const printer = struct {
    pub fn printf(comptime formatString: [:0]const u8, arguments: anytype) void {
        comptime var counter: i32 = 0;

        inline for (formatString) |c| {
            if (c == '{') {
                printnf("Got one");
            } else if (c == '}') {
                printnf("Got another");
                counter += 1;
            }
        }

        comptime if (arguments.len != counter) {
            @compileError("Didn't provide enough " ++ usizeToString(arguments.len) ++ " is what I got");
        };
    }

    pub fn printnf(comptime formatString: [:0]const u8) void {
        write(0, @intFromPtr(&formatString[0]), formatString.len);
    }
};
