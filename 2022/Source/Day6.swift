import Foundation

struct Day6 {
    /// Answer: 1361
    func puzzle1() throws {
        print("[Day 6, Puzzle 1] processing...")
        let input = try Input.data(for: "day6.txt")
        let answer = firstRunOfUniqueCharacters(input: input, count: 4)!
        print("[Day 6, Puzzle 1] answer: \(answer)")
    }

    /// Answer: 3263
    func puzzle2() throws {
        print("[Day 6, Puzzle 2] processing...")
        let input = try Input.data(for: "day6.txt")
        let answer = firstRunOfUniqueCharacters(input: input, count: 14)!
        print("[Day 6, Puzzle 2] answer: \(answer)")
    }

    private func firstRunOfUniqueCharacters(input: String, count: Int) -> Int? {
        var buffer: [Character] = []

        for (index, character) in input.enumerated() {
            buffer.append(character)
            guard buffer.count == count else { continue }

            if Set(buffer).count == count {
                return index + 1
            } else {
                buffer.removeFirst()
            }
        }

        return nil
    }
}
