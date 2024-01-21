// TODO: add part 2 description here
// -----------------------------------------------------------------------------
const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

fn solve(text: []const u8) !u32 {
    _ = text; // todo: implement this
    return 0;
}

pub fn main() !void {
    const answer = try solve(@embedFile("./input.txt"));
    print("{d}\n", .{answer});
}

test {
    const test_input =
        \\TODO: add test input here
    ;
    const answer = try solve(test_input);
    print("answer: {d}\n", .{answer});
    assert(answer == 123);
}
