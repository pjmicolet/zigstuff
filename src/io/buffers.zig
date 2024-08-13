const write = @import("../arch/x86/syscalls.zig").write;

pub fn FixedLengthOutputBuffer(comptime fd: usize, comptime bufSize: usize) type {
    return struct {
        fd: usize = fd,
        buf: [bufSize]u8 = undefined,
        usedSize: usize = 0,

        const Self = @This();

        pub inline fn writeToBuffer(self: *Self, bytes: []const u8) void {
            if ((self.usedSize + bytes.len) >= self.buf.len) {
                self.flush();
                @memset(self.buf[0..self.buf.len], 0);
                self.usedSize = 0;
            }
            @memcpy(self.buf[self.usedSize .. self.usedSize + bytes.len], bytes);
            self.usedSize += bytes.len;
        }

        pub inline fn flush(self: *Self) void {
            write(self.fd, @intFromPtr(&self.buf[0]), self.usedSize);
            self.usedSize = 0;
            @memset(self.buf[0..self.buf.len], '0');
        }
    };
}

// This is needed because if you call FixedLengthOutputBuffer you'd just get the type not an actual instance.
pub fn fixedLengthOutputBuffer(comptime fd: usize, comptime bufSize: usize) FixedLengthOutputBuffer(fd, bufSize) {
    return .{};
}
