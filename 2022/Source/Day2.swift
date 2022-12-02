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

    enum Outcome {
        case win, lose, draw

        init(_ string: String) {
            switch string {
            case "X":
                self = .lose
            case "Y":
                self = .draw
            case "Z":
                self = .win
            default:
                fatalError("Invalid input")
            }
        }

        func move(for opponent: Move) -> Move {
            switch self {
            case .win:
                switch opponent {
                case .rock: return .paper
                case .scissors: return .rock
                case .paper: return .scissors
                }
            case .lose:
                switch opponent {
                case .rock: return .scissors
                case .scissors: return .paper
                case .paper: return .rock
                }
            case .draw:
                return opponent
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
        let games = try parse1()
        let total = games
            .map { $0.score() }
            .reduce(0, +)
        print("[Day 2, Puzzle 1] answer: \(total)")
    }

    /// Answer: 13600
    func puzzle2() throws {
        print("[Day 2, Puzzle 2] processing...")
        let games = try parse2()
        let total = games
            .map { $0.score() }
            .reduce(0, +)
        print("[Day 2, Puzzle 2] answer: \(total)")
    }

    private func parse() throws -> [[String]] {
        try Input
            .data(for: "day2.txt")
            .components(separatedBy: "\n")
            .compactMap {
                $0.isEmpty ? nil : $0.components(separatedBy: " ")
            }
    }

    private func parse1() throws -> [Game] {
        try parse().map {
            Game(me: .init($0[1]), opponent: .init($0[0]))
        }
    }

    private func parse2() throws -> [Game] {
        try parse().map { line in
            let opponent = Move(line[0])
            let me = Outcome(line[1]).move(for: opponent)
            return Game(me: me, opponent: opponent)
        }
    }
}
