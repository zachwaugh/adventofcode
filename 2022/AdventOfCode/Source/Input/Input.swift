import Foundation

struct Input {
    private static let directory = URL(fileURLWithPath: "\(NSHomeDirectory())/code/adventofcode/2022/AdventOfCode/Source/Input/")

    static func day1() throws -> String {
        try String(contentsOf: url(for: "day1.txt"))
    }

    private static func url(for file: String) -> URL {
        directory.appendingPathComponent(file)
    }
}
