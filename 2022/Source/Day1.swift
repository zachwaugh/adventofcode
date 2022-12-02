import Foundation

struct Day1 {
    /// Answer: 70369
    func puzzle1() throws {
        print("[Day 1, Puzzle 1] running...")
        let maxCalories = try elves().max()!
        print("[Day 1, Puzzle 1] answer: \(maxCalories)")
    }

    /// Answer: 203002
    func puzzle2() throws {
        print("[Day 1, Puzzle 2] running...")
        let topThreeTotal = try elves()
            .sorted()
            .reversed()
            .prefix(3)
            .reduce(0, +)
        print("[Day 1, Puzzle 2] answer: \(topThreeTotal)")
    }

    private func elves() throws -> [Int] {
        try Input
            .data(for: "day1.txt")
            .components(separatedBy: "\n\n")
            .map {
                total($0.components(separatedBy: "\n"))
            }
    }

    private func total(_ calories: [String]) -> Int {
        calories
            .compactMap { Int($0) }
            .reduce(0, +)
    }
}
