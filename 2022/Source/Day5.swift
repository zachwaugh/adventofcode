import Foundation

struct Day5 {
    typealias Move = (count: Int, source: Int, destination: Int)

    /// Answer: FCVRLMVQP
    func puzzle1() throws {
        print("[Day 5, Puzzle 1] processing...")
        let lines = try Input.data(for: "day5.txt").components(separatedBy: "\n\n")
        var stacks = parseCrates(lines[0])
        let moves = parseMoves(lines[1])

        for move in moves {
            let crates = stacks[move.source - 1].suffix(move.count).reversed()
            stacks[move.destination - 1] += crates
            stacks[move.source - 1].removeLast(move.count)
        }

        let answer = stacks.reduce(into: "") { partialResult, stack in
            partialResult += stack.last!
        }

        print("[Day 5, Puzzle 1] answer: \(answer)")
    }

    func puzzle2() throws {
        print("[Day 5, Puzzle 2] unimplemented")
    }

    private func parseCrates(_ input: String) -> [[String]] {
        let rows = input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: "\n")
            .dropLast()

        var stacks: [[String]] = []

        for row in rows.reversed() {
            let columns = parseIntoColumns(row)
            for (index, column) in columns.enumerated() {
                guard !column.isEmpty else { continue }

                let crate = column
                    .replacingOccurrences(of: "[", with: "")
                    .replacingOccurrences(of: "]", with: "")

                if stacks.indices.contains(index) {
                    stacks[index].append(crate)
                } else {
                    stacks.append([crate])
                }
            }
        }

        return stacks
    }

    private func parseIntoColumns(_ row: String) -> [String] {
        var columns: [String] = []

        for index in stride(from: 0, to: row.count, by: 4) {
            let start = row.index(row.startIndex, offsetBy: index)
            let end = row.index(start, offsetBy: index + 4 < row.count ? 4 : 3)
            let column = String(row[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
            columns.append(column)
        }

        return columns
    }

    private func parseMoves(_ input: String) -> [Move] {
        input
            .components(separatedBy: .newlines)
            .map { line in
                let numbers = line
                    .components(separatedBy: " ")
                    .compactMap { Int($0) }
                return (numbers[0], numbers[1], numbers[2])
            }
    }
}
