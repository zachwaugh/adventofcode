import Foundation

struct Day4 {
    typealias Pair = (ClosedRange<Int>, ClosedRange<Int>)

    /// Answer: 560
    func puzzle1() throws {
        print("[Day 4/Puzzle 1] processing...")
        let answer = try parse()
            .reduce(into: 0) { partialResult, pair in
                if pair.0.contains(pair.1) || pair.1.contains(pair.0) {
                    partialResult += 1
                }
            }
        print("[Day 4/Puzzle 1] answer: \(answer)")
    }

    /// Answer: 839
    func puzzle2() throws {
        print("[Day 4/Puzzle 2] processing...")
        let answer = try parse()
            .reduce(into: 0) { partialResult, pair in
                if pair.0.overlaps(pair.1) || pair.1.overlaps(pair.0) {
                    partialResult += 1
                }
            }
        print("[Day 4/Puzzle 2] answer: \(answer)")
    }

    private func parse() throws -> [Pair] {
        try Input.data(for: "day4.txt")
            .components(separatedBy: "\n")
            .map { line -> Pair in
                let pairs = line.components(separatedBy: ",")
                let elf1 = parseRange(pairs[0])
                let elf2 = parseRange(pairs[1])
                return (elf1, elf2)
            }
    }

    private func parseRange(_ input: String) -> ClosedRange<Int> {
        let parts = input.components(separatedBy: "-")
        let start = Int(parts[0])!
        let end = Int(parts[1])!
        return start...end
    }
}

private extension ClosedRange<Int> {
    func contains(_ range: ClosedRange<Int>) -> Bool {
        lowerBound <= range.lowerBound && upperBound >= range.upperBound
    }
}
