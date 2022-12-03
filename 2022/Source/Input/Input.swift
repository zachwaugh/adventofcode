import Foundation

struct Input {
    private static let directory = URL(fileURLWithPath: "\(NSHomeDirectory())/code/adventofcode/2022/Source/Input/")

    static func data(for file: String) throws -> String {
        try String(contentsOf: url(for: file)).trimmingCharacters(in: .newlines)
    }

    private static func url(for file: String) -> URL {
        directory.appendingPathComponent(file)
    }
}
