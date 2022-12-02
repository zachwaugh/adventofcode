import Foundation

struct Day2 {
    enum Move {
        case rock, paper, scissors

        var score: Int {
            switch self {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissors:
                return 3
            }
        }

        init(_ string: String) {
            switch string {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissors
            default:
                fatalError("Invalid input")
            }
        }
    }

    struct Game {
        let me: Move
        let opponent: Move

        func score() -> Int {
            switch (me, opponent) {
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
                // Draw
                return 3 + me.score
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                // Win
                return 6 + me.score
            default:
                // Loss
                return 0 + me.score
            }
        }
    }

    /// Answer: 11386
    func puzzle1() throws {
        print("[Day 2, Puzzle 1] processing...")
        let games = try parse()
        let total = games
            .map { $0.score() }
            .reduce(0, +)
        print("[Day 2, Puzzle 1] answer: \(total)")
    }

    func puzzle2() throws {
        
    }

    private func parse() throws -> [Game] {
        try Input
            .data(for: "day2.txt")
            .components(separatedBy: "\n")
            .compactMap {
                $0.isEmpty ? nil : $0.components(separatedBy: " ")
            }
            .map {
                Game(me: .init($0[1]), opponent: .init($0[0]))
            }
    }
}
