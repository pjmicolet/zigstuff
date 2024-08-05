const write = @import("./syscalls.zig").write;
const expect = @import("./utils.zig").compile_asserts.expect;
const usizeToString = @import("./utils.zig").compile_error_utils.usizeToString;

const PrintBufferInit = @import("./buffers.zig").fixedLengthOutputBuffer;

pub const printer = struct {
    const parserPhase = enum { normal, open };
    const openArgParse = '{';
    const closeArgParse = '}';
    const bufferSize = 4096;

    var buff = PrintBufferInit(1, bufferSize);

    pub fn printf(comptime formatString: [:0]const u8, arguments: anytype) void {
        comptime var phase = parserPhase.normal;
        comptime var counter: i32 = 0;
        comptime var nextSection: usize = 0;

        inline for (formatString, 0..) |c, i| {
            switch (phase) {
                parserPhase.normal => {
                    if (c == openArgParse) {
                        buff.writeToBuffer(formatString[nextSection..i]);
                        phase = parserPhase.open;
                    }
                },
                parserPhase.open => {
                    if (c == closeArgParse) {
                        buff.writeToBuffer(arguments[counter]);
                        phase = parserPhase.normal;
                        counter += 1;
                        nextSection = i + 1;
                    }
                },
            }
        }
        if (nextSection < formatString.len) {
            buff.writeTobuffer(formatString[nextSection..formatString.len]);
        }
        buff.flush();

        comptime if (arguments.len != counter) {
            @compileError("Didn't provide enough " ++ usizeToString(arguments.len) ++ " is what I got");
        };
    }

    /// Non formatted string, doesn't have to be comptime
    pub fn printnf(string: [:0]const u8) void {
        if (string.len < bufferSize) {
            write(1, @intFromPtr(&string[0]), string.len);
        } else {
            breakDownNfPrint(string);
        }
    }

    fn breakDownNfPrint(string: [:0]const u8) void {
        var index: usize = 0;

        while (true) {
            var end = index + bufferSize;
            if (end > string.len) {
                end = string.len;
                buff.writeToBuffer(string[index..end]);
                break;
            } else {
                buff.writeToBuffer(string[index..end]);
            }
            index = end;
        }
        buff.flush();
    }
};
