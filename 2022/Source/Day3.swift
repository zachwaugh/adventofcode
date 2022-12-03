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

    /// Answer: 2425
    func puzzle2() throws {
        print("[Day 3/Puzzle 2] processing...")
        let rucksacks = try Input.data(for: "day3.txt")
            .components(separatedBy: "\n")

        var groups: [[String]] = []
        for index in stride(from: 0, to: rucksacks.count, by: 3) {
            groups.append(Array(rucksacks[index..<index+3]))
        }

        let answer = groups
            .map { group in
                let elf1 = Set(group[0])
                let elf2 = Set(group[1])
                let elf3 = Set(group[2])
                return elf1.intersection(elf2).intersection(elf3)
            }
            .reduce(0) { result, set in
                assert(set.count == 1)
                return result + priority(set.first!)
            }
        print("[Day 3/Puzzle 2] answer: \(answer)")
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
