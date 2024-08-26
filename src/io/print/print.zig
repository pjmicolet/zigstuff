const write = @import("../../arch/x86/syscalls.zig").write;
const expect = @import("../../utils/utils.zig").compile_asserts.expect;
const usizeToString = @import("../../utils/utils.zig").compile_error_utils.usizeToString;
const PrintBufferInit = @import("../buffers.zig").fixedLengthOutputBuffer;
const AnyPrinter = @import("converter.zig").AnyPrinter;

pub const Printer = struct {
    const parserPhase = enum { normal, open };
    const openArgParse = '{';
    const closeArgParse = '}';
    const bufferSize = 4096;

    var buff = PrintBufferInit(1, bufferSize);

    pub fn printf(comptime formatString: [:0]const u8, arguments: anytype) void {
        comptime var phase = parserPhase.normal;
        comptime var counter: usize = 0;
        comptime var nextSection: usize = 0;

        inline for (formatString, 0..) |c, i| {
            switch (phase) {
                parserPhase.normal => {
                    if (c == openArgParse) {
                        if (i != 0) {
                            buff.writeToBuffer(formatString[nextSection..i]);
                        }
                        phase = parserPhase.open;
                    }
                    continue;
                },
                parserPhase.open => {
                    if (c == closeArgParse) {
                        AnyPrinter.convertAny(arguments[counter], &buff);
                        phase = parserPhase.normal;
                        counter += 1;
                        nextSection = i + 1;
                    }
                    continue;
                },
            }
        }

        if (nextSection < formatString.len) {
            buff.writeToBuffer(formatString[nextSection..formatString.len]);
        }
        //TODO: Check if I should always flush
        buff.flush();

        comptime if (arguments.len != counter) {
            @compileError("Didn't provide enough " ++ usizeToString(arguments.len) ++ " is what I got vs " ++ usizeToString(counter));
        };
    }

    /// Non formatted string, doesn't have to be comptime
    pub fn print(string: [:0]const u8) void {
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
