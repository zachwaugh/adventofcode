import Foundation

struct Day7 {
    typealias File = (filename: String, bytes: Int64)
    typealias Directories = [String: [File]]

    /// Answer: 1306611
    func puzzle1() throws {
        print("[Day 7, Puzzle 1] processing...")
        let output = try Input.data(for: "day7.txt").components(separatedBy: "\n")
        var directoryStack: [String] = []
        var lastCommand: String?
        var directories: Directories = [:]

        for line in output {
            if line.hasPrefix("$") {
                // Command
                let args = Array(line.components(separatedBy: " ").dropFirst())
                let command = args[0]
                switch command {
                case "cd":
                    if args[1] == ".." {
                        _ = directoryStack.popLast()
                    } else {
                        directoryStack.append(args[1])
                    }
                case "ls":
                    break
                default:
                    print("Unhandled command: \(command)")
                }

                lastCommand = command
            } else if let lastCommand {
                // Output
                switch lastCommand {
                case "ls":
                    let parts = line.components(separatedBy: " ")
                    let path = path(for: directoryStack)
                    if parts[0] == "dir" {
                        let dirPath = self.path(for: directoryStack + [parts[1]])
                        directories[dirPath] = []
                    } else {
                        directories[path, default: []].append((filename: parts[1], bytes: Int64(parts[0])!))
                    }
                default:
                    fatalError("Unhandled output for last command: \(lastCommand)")
                }
            } else {
                fatalError("Unhandled output, not command or command output: \(line)")
            }
        }

        var answer: Int64 = 0

        for directory in directories {
            let size = totalSize(for: directory.key, in: directories)
            if size < 100000 {
                answer += size
            }
        }
        print("[Day 7, Puzzle 1] answer: \(answer)")
    }

    func puzzle2() throws {
        print("[Day 7, Puzzle 2] processing...")
        print("[Day 7, Puzzle 2] answer: ")
    }

    private func path(for directories: [String]) -> String {
        var path = directories.joined(separator: "/")
        if path.hasPrefix("//") {
            path.removeFirst()
        }

        return path
    }

    private func totalSize(for path: String, in directories: Directories) -> Int64 {
        var total: Int64 = 0

        for directory in directories {
            if directory.key.hasPrefix(path) {
                total += totalSize(directory.value)
            }
        }

        return total
    }

    private func totalSize(_ files: [File]) -> Int64 {
        files.reduce(0) { partialResult, file in
            partialResult + file.bytes
        }
    }
}
