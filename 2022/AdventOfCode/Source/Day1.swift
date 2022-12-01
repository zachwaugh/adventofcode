import Foundation

struct Day1 {
    /// Answer: 70369
    func puzzle1() throws {
        print("[Day 1, Puzzle 1] running...")
        let input = try Input.day1Puzzle1()
        let elves = input
            .components(separatedBy: "\n\n")
            .map {
                total($0.components(separatedBy: "\n"))
            }

        let maxCalories = elves.max()!
        print("[Day 1, Puzzle 1] answer: \(maxCalories)")
    }

    private func total(_ calories: [String]) -> Int {
        calories
            .compactMap { Int($0) }
            .reduce(0, +)
    }
}
