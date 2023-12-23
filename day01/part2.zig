// --- Part Two ---

// Your calculation isn't quite right. It looks like some of the digits are
// actually spelled out with letters: one, two, three, four, five, six, seven,
// eight, and nine also count as valid "digits".

// Equipped with this new information, you now need to find the real first and
// last digit on each line. For example:

// two1nine
// eightwothree
// abcone2threexyz
// xtwone3four
// 4nineeightseven2
// zoneight234
// 7pqrstsixteen

// In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
// Adding these together produces 281.

// What is the sum of all of the calibration values?
// ----------------------------------------------------------------------------

const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;
const allocator = std.heap.page_allocator;

fn solve(text: []const u8) !u32 {
    var lines = std.mem.split(u8, text, "\n");

    var sum: u32 = 0;
    while (lines.next()) |line| {
        // Skip empty lines, like at the end of the file
        if (line.len == 0) continue;

        var firstDigit: u8 = '-';
        var firstDigitIndex: usize = std.math.maxInt(usize);
        var lastDigit: u8 = '-';
        var lastDigitIndex: usize = std.math.minInt(usize);

        // Store the first and last occurrence of a digit
        for (line, 0..) |char, index| {
            if (char >= '0' and char <= '9') {
                lastDigit = char;
                lastDigitIndex = index;
                if (firstDigit == '-') {
                    firstDigit = char;
                    firstDigitIndex = index;
                }
            }
        }

        const words = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
        for (words, 0..) |word, wordIndex| {
            const wordInt = @as(u8, @intCast(wordIndex));
            // If the word's position in the line is smaller than the firstDigit, set that as the index
            const firstIndex = std.mem.indexOf(u8, line, word) orelse continue;
            if (firstIndex < firstDigitIndex) {
                firstDigit = '0' + wordInt;
                firstDigitIndex = firstIndex;
            }
            // If the word's position in the line is larger than the lastDigit, set that as the index
            const lastIndex = std.mem.lastIndexOf(u8, line, word) orelse continue;
            if (lastIndex > lastDigitIndex) {
                lastDigit = '0' + wordInt;
                lastDigitIndex = lastIndex;
            }
        }

        assert(firstDigit != '-' and lastDigit != '-');

        // Convert the two digit chars into an int
        const numberBuf = try allocator.alloc(u8, 2);
        const numString = try std.fmt.bufPrint(
            numberBuf,
            "{c}{c}",
            .{ firstDigit, lastDigit },
        );
        const num = try std.fmt.parseInt(u32, numString, 10);

        sum += num;
    }

    return sum;
}

pub fn main() !void {
    const answer = try solve(@embedFile("./input.txt"));
    print("{d}\n", .{answer});
}

test {
    const test_input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    assert(try solve(test_input) == 281);
}
