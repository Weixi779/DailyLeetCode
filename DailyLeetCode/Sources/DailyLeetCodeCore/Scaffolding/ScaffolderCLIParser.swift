import Foundation

public enum ScaffolderCLIParser {
    public static let usage = "Usage: swift run ProblemScaffolder scaffold --url=https://leetcode.cn/problems/<slug>/ [--tags=tag1,tag2] [--force] [--env=<path>]"

    public static func parse(arguments: [String]) throws -> GeneratorArguments {
        var args = GeneratorArguments()
        var input = arguments

        guard let first = input.first else {
            throw GeneratorError.helpRequested
        }
        switch first {
        case "scaffold", "s":
            input.removeFirst()
        case "help", "h", "--help", "-h":
            throw GeneratorError.helpRequested
        default:
            throw GeneratorError.unknownArgument(first)
        }

        var iterator = input.makeIterator()
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
            } else if arg == "--help" || arg == "-h" {
                throw GeneratorError.helpRequested
            } else {
                throw GeneratorError.unknownArgument(arg)
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
}
