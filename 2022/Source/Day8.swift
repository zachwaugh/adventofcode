import Foundation

struct Day8 {
    /// Answer: 1713
    func puzzle1() throws {
        print("[Day 8, Puzzle 1] processing...")
        let input = try Input.data(for: "day8.txt")

        let grid = input
            .components(separatedBy: "\n")
            .map { line in
                Array(line).compactMap { Int(String($0)) }
            }

        var answer = 0

        for (rowIndex, row) in grid.enumerated() {
            for (columnIndex, height) in row.enumerated() {
                let fromLeft = row[0..<columnIndex].max() ?? -1
                if fromLeft < height {
                    answer += 1
                    continue
                }

                let fromRight = row[columnIndex+1..<row.count].max() ?? -1
                if fromRight < height {
                    answer += 1
                    continue
                }

                let fromTop = grid[0..<rowIndex].map { $0[columnIndex] }.max() ?? -1
                if fromTop < height {
                    answer += 1
                    continue
                }

                let fromBottom = grid[rowIndex+1..<grid.count].map { $0[columnIndex] }.max() ?? -1
                if fromBottom < height {
                    answer += 1
                    continue
                }
            }
        }

        print("[Day 8, Puzzle 1] answer: \(answer)")
    }

    /// Answer: 268464
    func puzzle2() throws {
        print("[Day 8, Puzzle 2] processing...")
        let input = try Input.data(for: "day8.txt")

        let grid = input
            .components(separatedBy: "\n")
            .map { line in
                Array(line).compactMap { Int(String($0)) }
            }

        var answer = -1

        for (rowIndex, row) in grid.enumerated() {
            for (columnIndex, height) in row.enumerated() {
                var leftTrees = 0
                var rightTrees = 0
                var upTrees = 0
                var downTrees = 0

                let toLeft = row[0..<columnIndex]
                for tree in toLeft.reversed() {
                    leftTrees += 1
                    if tree >= height {
                        break
                    }
                }

                let toRight = row[columnIndex+1..<row.count]
                for tree in toRight {
                    rightTrees += 1
                    if tree >= height {
                        break
                    }
                }

                let toTop = grid[0..<rowIndex].map { $0[columnIndex] }
                for tree in toTop.reversed() {
                    upTrees += 1
                    if tree >= height {
                        break
                    }
                }

                let toBottom = grid[rowIndex+1..<grid.count].map { $0[columnIndex] }
                for tree in toBottom {
                    downTrees += 1
                    if tree >= height {
                        break
                    }
                }

                let score = leftTrees * rightTrees * upTrees * downTrees
                if score > answer {
                    answer = score
                }
            }
        }

        print("[Day 8, Puzzle 2] answer: \(answer)")
    }
}
