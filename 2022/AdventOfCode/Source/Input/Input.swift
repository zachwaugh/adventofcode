import Foundation

struct Input {
    private static let directory = URL(fileURLWithPath: "\(NSHomeDirectory())/code/adventofcode/2022/AdventOfCode/Source/Input/")

    static func day1Puzzle1() throws -> String {
        try String(contentsOf: url(for: "day1_puzzle1_input.txt"))
    }

    private static func url(for file: String) -> URL {
        directory.appendingPathComponent(file)
    }
}
