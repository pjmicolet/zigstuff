pub const mem = struct {
    pub fn equals(lhs: []const u8, rhs: []const u8) bool {
        if (lhs.len != rhs.len) {
            return false;
        }
        for (0..lhs.len) |i| {
            if (lhs[i] != rhs[i]) {
                return false;
            }
        }
        return true;
    }
};

pub const compile_asserts = struct {
    pub fn expect(comptime result: bool) void {
        if (result != true) {
            @compileError("This was wrong");
        }
    }
};

pub const compile_error_utils = struct {
    pub fn usizeToString(comptime num: usize) []const u8 {
        comptime var data: [8]u8 = undefined;
        comptime var index = 0;
        var numMod = num;

        index = 8;
        inline while (numMod > 0) {
            index -= 1;
            const thing = numMod % 10;
            data[index] = 0x30 | thing;
            numMod = numMod / 10;
        }

        return data[index..8];
    }
};

test "Int to String" {
    comptime {
        const data = compile_error_utils.usizeToString(1234);
        compile_asserts.expect(mem.equals(data, "1234") == true);
    }
}
