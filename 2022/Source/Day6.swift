import Foundation

struct Day6 {
    /// Answer: 1361
    func puzzle1() throws {
        print("[Day 6, Puzzle 1] processing...")
        let input = try Input.data(for: "day6.txt")
        var buffer: [Character] = []
        var answer = -1

        for (index, character) in input.enumerated() {
            buffer.append(character)
            guard buffer.count == 4 else { continue }

            if Set(buffer).count == 4 {
                answer = index + 1
                break
            } else {
                buffer.removeFirst()
            }
        }

        print("[Day 6, Puzzle 1] answer: \(answer), letters: \(String(buffer))")
    }

    func puzzle2() throws {
        
    }
}
