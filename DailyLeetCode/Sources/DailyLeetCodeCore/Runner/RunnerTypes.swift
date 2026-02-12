import Foundation

public struct RunOptions {
    public var id: String?
    public var tag: String?
    public var includeAll: Bool
    public var debug: Bool

    public init(id: String? = nil, tag: String? = nil, includeAll: Bool = false, debug: Bool = false) {
        self.id = id
        self.tag = tag
        self.includeAll = includeAll
        self.debug = debug
    }
}

public struct ListOptions {
    public var includeAll: Bool
    public var tag: String?

    public init(includeAll: Bool = false, tag: String? = nil) {
        self.includeAll = includeAll
        self.tag = tag
    }
}

public enum RunnerCommand {
    case run(RunOptions)
    case fetch(String)
    case list(ListOptions)
    case help
}

public struct RunnerCLIError: Error {
    public let message: String

    public init(_ message: String) {
        self.message = message
    }
}

public enum RunnerHelpRequestedError: Error {
    case runHelp
    case listHelp
    case fetchHelp

    public var message: String {
        switch self {
        case .runHelp:
            return "run 用法: swift run DailyLeetCodeRunner run [--enabled|--all] [--id <ID> | --tag <TAG>] [--debug]"
        case .listHelp:
            return "list 用法: swift run DailyLeetCodeRunner list [--enabled|--all] [--tag <TAG>]"
        case .fetchHelp:
            return "fetch 用法: swift run DailyLeetCodeRunner fetch --url <leetcode-url>"
        }
    }
}

public enum RunnerExitCode: Int32 {
    case success = 0
    case failure = 1
    case noMatches = 2
    case usage = 64
}
