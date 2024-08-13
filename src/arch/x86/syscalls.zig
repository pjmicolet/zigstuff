pub inline fn exit(exit_code: i32) usize {
    return syscall_1(60, exit_code);
}

pub inline fn write(fd: usize, buffer: usize, buff_size: usize) void {
    _ = syscall_3(1, fd, buffer, buff_size);
}

fn syscall_1(scallnum: i32, arg1: i32) usize {
    return asm volatile ("syscall"
        : [ret] "={rax}" (-> usize),
        : [scallnum] "{rax}" (scallnum),
          [arg1] "{rdi}" (arg1),
        : "rcx", "r9", "r8"
    );
}

fn syscall_3(scallnum: i32, arg1: usize, arg2: usize, arg3: usize) usize {
    return asm volatile ("syscall"
        : [ret] "={rax}" (-> usize),
        : [scallnum] "{rax}" (scallnum),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
          [arg3] "{rdx}" (arg3),
        : "rcx", "r9", "r8"
    );
}
