import DailyLeetCodeCore
import LeetCodeAPI
import Foundation

struct GeneratorArguments {
    var url: URL?
    var tags: [String] = []
    var force: Bool = false
    var envPath: String = ".leetcode.env"
}

@main
struct ProblemScaffolder {
    static func main() async {
        do {
            try await run()
        } catch {
            fputs("Error: \(error)\n", stderr)
            exit(1)
        }
    }

    private static func run() async throws {
        let arguments = parseArguments()
        guard let problemURL = arguments.url else {
            printUsage()
            throw GeneratorError.missingURL
        }

        let client = try ProblemMetadataFetcher.makeClient(envFileRelativePath: arguments.envPath)
        let details = try await client.fetchProblem(from: problemURL)

        let normalizedID = normalizedID(details.id)
        let typeSuffix = makeTypeSuffix(from: details.slug)
        let typeName = "LT\(normalizedID)\(typeSuffix)"
        let fileName = "LT\(normalizedID)_\(typeSuffix).swift"

        let markdown = await details.markdownSummary()
        let docComment = docComment(from: markdown)
        let displayTitle = details.translatedTitle?.isEmpty == false ? details.translatedTitle! : details.title
        let tagsLiteral = tagLiteral(from: arguments.tags)

        let fileContents = """
        import Foundation

        \(docComment)
        public struct \(typeName): LeetCodeTask {
            public let id = \"\(normalizedID)\"
            public let title = \"\(escape(displayTitle))\"
            public let url = URL(string: \"https://leetcode.cn/problems/\(details.slug)/\")!
            public let tags: [ProblemTag] = \(tagsLiteral)
        
            public init() {}
        
            // TODO: 编写题解代码与本地调试入口
        }
        """
        .trimmingCharacters(in: .whitespacesAndNewlines)

        let basePath = FileManager.default.currentDirectoryPath
        let problemsDir = URL(fileURLWithPath: basePath).appendingPathComponent("Sources/DailyLeetCodeCore/Problems", isDirectory: true)
        try FileManager.default.createDirectory(at: problemsDir, withIntermediateDirectories: true)
        let fileURL = problemsDir.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path), arguments.force == false {
            throw GeneratorError.fileAlreadyExists(fileURL.path)
        }

        try fileContents.write(to: fileURL, atomically: true, encoding: .utf8)
        try updateProblemCatalog(with: typeName, basePath: basePath)
        print("Generated \(fileName)")
    }

    private static func parseArguments() -> GeneratorArguments {
        var args = GeneratorArguments()
        var iterator = CommandLine.arguments.dropFirst().makeIterator()
        while let arg = iterator.next() {
            if arg.hasPrefix("--url=") {
                let value = String(arg.dropFirst(6))
                args.url = URL(string: value)
            } else if arg == "--url", let value = iterator.next() {
                args.url = URL(string: value)
            } else if arg.hasPrefix("--tags=") {
                let value = String(arg.dropFirst(7))
                args.tags = tags(from: value)
            } else if arg == "--tags", let value = iterator.next() {
                args.tags = tags(from: value)
            } else if arg == "--force" {
                args.force = true
            } else if arg.hasPrefix("--env=") {
                args.envPath = String(arg.dropFirst(6))
            } else if arg == "--env", let value = iterator.next() {
                args.envPath = value
            }
        }
        return args
    }

    private static func tags(from string: String) -> [String] {
        string
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private static func docComment(from markdown: String) -> String {
        markdown
            .components(separatedBy: .newlines)
            .map { line in
                if line.trimmingCharacters(in: .whitespaces).isEmpty {
                    return "///"
                } else {
                    return "/// \(line)"
                }
            }
            .joined(separator: "\n")
    }

    private static func normalizedID(_ id: String) -> String {
        if let value = Int(id) {
            return String(format: "%04d", value)
        }
        return id
    }

    private static func makeTypeSuffix(from slug: String) -> String {
        slug
            .split { !$0.isLetter && !$0.isNumber }
            .map { part in
                part.capitalized
            }
            .joined()
    }

    private static func tagLiteral(from tags: [String]) -> String {
        guard tags.isEmpty == false else { return "[]" }
        let values = tags.map { literal(forTag: $0) }.joined(separator: ", ")
        return "[\(values)]"
    }

    private static func literal(forTag raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()
        switch lower {
        case "daily": return ".daily"
        case "weekly": return ".weekly"
        case "contest": return ".contest"
        default:
            break
        }
        let parts = trimmed.split(separator: ":", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            let prefix = parts[0].lowercased()
            let value = escape(parts[1])
            switch prefix {
            case "topic": return ".topic(\"\(value)\")"
            case "company": return ".company(\"\(value)\")"
            case "difficulty": return ".difficulty(\"\(value)\")"
            default: break
            }
        }
        return ".custom(\"\(escape(trimmed))\")"
    }

    private static func updateProblemCatalog(with typeName: String, basePath: String) throws {
        let catalogURL = URL(fileURLWithPath: basePath).appendingPathComponent("Sources/DailyLeetCodeCore/Problems/ProblemCatalog.swift")
        var content = try String(contentsOf: catalogURL)
        if content.contains("\(typeName)()") { return }
        guard let insertionRange = content.range(of: "\n    ]", options: .backwards) else {
            throw GeneratorError.catalogFormatInvalid
        }
        let insertion = "        \(typeName)(),\n"
        let prefix = content[..<insertionRange.lowerBound]
        let suffix = content[insertionRange.lowerBound...]
        content = String(prefix) + insertion + String(suffix)
        try content.write(to: catalogURL, atomically: true, encoding: .utf8)
    }

    private static func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }

    private static func printUsage() {
        print("Usage: swift run ProblemScaffolder --url=https://leetcode.cn/problems/<slug>/ [--tags=tag1,tag2] [--force]")
    }
}

enum GeneratorError: Error, CustomStringConvertible {
    case missingURL
    case fileAlreadyExists(String)
    case catalogFormatInvalid

    var description: String {
        switch self {
        case .missingURL:
            return "Missing --url argument"
        case .fileAlreadyExists(let path):
            return "File already exists at \(path). Pass --force to overwrite."
        case .catalogFormatInvalid:
            return "ProblemCatalog.swift structure not recognized"
        }
    }
}
