import Foundation

struct Day3 {
    /// Answer: 8053
    func puzzle1() throws {
        print("[Day 3/Puzzle 1] processing...")
        let answer = try Input.data(for: "day3.txt")
            .components(separatedBy: "\n")
            .map { rucksack in
                let compartment1 = Set(rucksack.prefix(rucksack.count / 2))
                let compartment2 = Set(rucksack.suffix(rucksack.count / 2))
                return compartment1.intersection(compartment2)
            }
            .reduce(0) { result, set in
                assert(set.count == 1)
                return result + priority(set.first!)
            }

        print("[Day 3/Puzzle 1] answer: \(answer)")
    }

    func puzzle2() throws {
        print("[Day 3/Puzzle 2] processing...")
        print("[Day 3/Puzzle 2] answer: ????")

    }

    // Lowercase item types a through z have priorities 1 through 26.
    // Uppercase item types A through Z have priorities 27 through 52.
    private func priority(_ character: Character) -> Int {
        assert(character.isASCII && character.isLetter)

        // a = 97, 97 - 96 == 1
        // A = 65, 65 - 38 == 27
        let offset = character.isLowercase ? 96 : 38
        return Int(character.asciiValue!) - offset
    }
}
