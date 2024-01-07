// --- Part Two ---

// The Elf says they've stopped producing snow because they aren't getting any
// water! He isn't sure why the water stopped; however, he can show you how to
// get to the water source to check it out for yourself. It's just up ahead!

// As you continue your walk, the Elf poses a second question: in each game you
// played, what is the fewest number of cubes of each color that could have been
// in the bag to make the game possible?

// Again consider the example games from earlier:

// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

//     In game 1, the game could have been played with as few as 4 red, 2 green,
// and 6 blue cubes. If any color had even one fewer cube, the game would have
// been impossible.
//     Game 2 could have been played with a minimum of 1 red, 3 green, and 4
// blue cubes.
//     Game 3 must have been played with at least 20 red, 13 green, and 6 blue
// cubes.
//     Game 4 required at least 14 red, 3 green, and 15 blue cubes.
//     Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.

// The power of a set of cubes is equal to the numbers of red, green, and blue
// cubes multiplied together. The power of the minimum set of cubes in game 1 is
// 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these
// five powers produces the sum 2286.

// For each game, find the minimum set of cubes that must have been present.
// What is the sum of the power of these sets?
// -----------------------------------------------------------------------------

const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

fn solve(text: []const u8) !u32 {
    // check for and remove trailing newline
    var trimmedText = text;
    if (text.len > 0 and text[text.len - 1] == '\n') {
        trimmedText = text[0 .. text.len - 1];
    }

    var lines = std.mem.split(u8, trimmedText, "\n");

    var sum: u32 = 0;
    while (lines.next()) |line| {
        var games = std.mem.split(u8, line, ": ");
        _ = games.next() orelse unreachable;
        const game = games.next() orelse unreachable;

        var cubes = std.mem.split(u8, game, "; ");
        var maxRedCount: u32 = 0;
        var maxGreenCount: u32 = 0;
        var maxBlueCount: u32 = 0;

        while (cubes.next()) |cube| {
            var colors = std.mem.split(u8, cube, ", ");
            while (colors.next()) |color| {
                var colorAndCount = std.mem.split(u8, color, " ");
                const countString = colorAndCount.next() orelse unreachable;
                const colorString = colorAndCount.next() orelse unreachable;
                const count = try std.fmt.parseInt(u32, countString, 10);
                switch (colorString[0]) {
                    'r' => {
                        if (count > maxRedCount) {
                            maxRedCount = count;
                        }
                    },
                    'g' => {
                        if (count > maxGreenCount) {
                            maxGreenCount = count;
                        }
                    },
                    'b' => {
                        if (count > maxBlueCount) {
                            maxBlueCount = count;
                        }
                    },
                    else => unreachable,
                }
            }
        }
        const power = maxRedCount * maxGreenCount * maxBlueCount;
        sum += power;
    }

    return sum;
}

pub fn main() !void {
    const answer = try solve(@embedFile("./input.txt"));
    print("{d}\n", .{answer});
}

test {
    const test_input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const answer = try solve(test_input);
    print("answer: {d}\n", .{answer});
    assert(answer == 2286);
}
