pub const AnyPrinter = struct {
    pub fn convertAny(value: anytype, outputbuff: anytype) void {
        switch (@typeInfo(@TypeOf(value))) {
            .Int, .ComptimeInt => {
                fromInteger(value, outputbuff);
            },
            .Array => {
                outputbuff.writeToBuffer("[");
                for (value, 0..) |item, i| {
                    convertAny(item, outputbuff);
                    if (i < (value.len - 1)) {
                        outputbuff.writeToBuffer(", ");
                    }
                }
                outputbuff.writeToBuffer("]");
            },
            .Pointer => {
                outputbuff.writeToBuffer(value);
            },
            else => {
                @compileError("convertAny doesn't support type");
            },
        }
    }

    fn fromInteger(data: anytype, outputbuff: anytype) void {
        var buffer: [8]u8 = undefined;
        var index: usize = 0;
        var numMod: usize = data;
        index = 8;
        while (numMod > 0) {
            index -= 1;
            const thing: u8 = @intCast(numMod % 10);
            buffer[index] = 0x30 | thing;
            numMod = numMod / 10;
        }
        outputbuff.writeToBuffer(&buffer);
    }
};
