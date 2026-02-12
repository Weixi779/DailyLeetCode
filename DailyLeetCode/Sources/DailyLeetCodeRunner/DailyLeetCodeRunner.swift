import DailyLeetCodeCore
import LeetCodeAPI
import Foundation

@MainActor
@main
struct DailyLeetCodeRunner {
    static func main() async {
        let code = await runAndExitCode()
        Foundation.exit(code.rawValue)
    }

    private static func runAndExitCode() async -> ExitCode {
        TaskCatalog.bootstrap().forEach { TaskRegistry.shared.register($0) }

        do {
            let command = try parse(arguments: Array(CommandLine.arguments.dropFirst()))
            return await execute(command)
        } catch let help as HelpRequestedError {
            print(help.message)
            return .success
        } catch let error as CLIError {
            fputs("参数错误：\(error.message)\n", stderr)
            fputs("使用帮助：swift run DailyLeetCodeRunner help\n", stderr)
            return .usage
        } catch {
            fputs("运行失败：\(error)\n", stderr)
            return .failure
        }
    }

    private static func parse(arguments: [String]) throws -> RunnerCommand {
        guard let first = arguments.first else {
            return .run(RunOptions())
        }

        switch first {
        case "run", "r":
            return .run(try parseRunOptions(from: Array(arguments.dropFirst())))
        case "fetch", "f":
            return .fetch(try parseFetchURL(from: Array(arguments.dropFirst())))
        case "list", "ls":
            return .list(try parseListOptions(from: Array(arguments.dropFirst())))
        case "help", "h", "--help", "-h":
            return .help
        default:
            if first.hasPrefix("-") {
                throw CLIError("未知命令或参数：\(first)")
            }
            throw CLIError("旧用法已移除，请使用 `run --id \(first)`")
        }
    }

    private static func parseRunOptions(from args: [String]) throws -> RunOptions {
        var options = RunOptions()
        var index = 0

        while index < args.count {
            let arg = args[index]
            switch arg {
            case "--all":
                options.includeAll = true
            case "--enabled":
                options.includeAll = false
            case "--debug":
                options.debug = true
            case "--help", "-h":
                throw HelpRequestedError.runHelp
            case "--id":
                guard index + 1 < args.count else { throw CLIError("--id 缺少值") }
                options.id = args[index + 1]
                index += 1
            case "--tag":
                guard index + 1 < args.count else { throw CLIError("--tag 缺少值") }
                options.tag = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--id=") {
                    options.id = String(arg.dropFirst(5))
                } else if arg.hasPrefix("--tag=") {
                    options.tag = String(arg.dropFirst(6))
                } else {
                    throw CLIError("run 不支持参数：\(arg)")
                }
            }
            index += 1
        }

        if options.id != nil, options.tag != nil {
            throw CLIError("--id 与 --tag 不能同时使用")
        }
        if options.includeAll, options.tag != nil {
            throw CLIError("--all 与 --tag 不能同时使用")
        }
        return options
    }

    private static func parseFetchURL(from args: [String]) throws -> String {
        guard !args.isEmpty else {
            throw CLIError("fetch 需要 --url 参数")
        }

        var urlValue: String?
        var index = 0
        while index < args.count {
            let arg = args[index]
            switch arg {
            case "--help", "-h":
                throw HelpRequestedError.fetchHelp
            case "--url":
                guard index + 1 < args.count else { throw CLIError("--url 缺少值") }
                urlValue = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--url=") {
                    urlValue = String(arg.dropFirst(6))
                } else {
                    throw CLIError("fetch 不支持参数：\(arg)")
                }
            }
            index += 1
        }

        guard let urlValue, !urlValue.isEmpty else {
            throw CLIError("fetch 需要 --url 参数")
        }
        return urlValue
    }

    private static func parseListOptions(from args: [String]) throws -> ListOptions {
        var options = ListOptions()
        var index = 0
        while index < args.count {
            let arg = args[index]
            switch arg {
            case "--all":
                options.includeAll = true
            case "--enabled":
                options.includeAll = false
            case "--help", "-h":
                throw HelpRequestedError.listHelp
            case "--tag":
                guard index + 1 < args.count else { throw CLIError("--tag 缺少值") }
                options.tag = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--tag=") {
                    options.tag = String(arg.dropFirst(6))
                } else {
                    throw CLIError("list 不支持参数：\(arg)")
                }
            }
            index += 1
        }
        return options
    }

    private static func execute(_ command: RunnerCommand) async -> ExitCode {
        switch command {
        case .help:
            printGeneralHelp()
            return .success
        case .run(let options):
            return executeRun(options: options)
        case .list(let options):
            return executeList(options: options)
        case .fetch(let urlString):
            return await fetchMetadata(for: urlString)
        }
    }

    private static func executeRun(options: RunOptions) -> ExitCode {
        let allTasks = TaskRegistry.shared.allTasks()
        var tasks = allTasks

        if let id = options.id {
            tasks = tasks.filter { isIDMatch(taskID: $0.id, input: id) }
        } else if let tag = options.tag {
            if options.includeAll == false {
                tasks = tasks.filter(\.isEnabled)
            }
            let targetTag = ProblemTag(tag)
            tasks = tasks.filter { $0.tags.contains(targetTag) }
        } else if options.includeAll == false {
            tasks = tasks.filter(\.isEnabled)
        }

        guard !tasks.isEmpty else {
            if options.includeAll == false, options.id == nil, options.tag == nil {
                print("当前没有启用题，请在题目里将 isEnabled 设为 true 再运行。")
            } else if let id = options.id {
                print("未找到题目：id=\(id)")
            } else if let tag = options.tag {
                print("未找到匹配标签：\(tag)")
            } else {
                print("没有匹配的可执行题目。")
            }
            return .noMatches
        }

        if options.debug {
            print("[debug] 将执行 \(tasks.count) 道题")
        }
        tasks.forEach { runTask($0, debug: options.debug) }
        return .success
    }

    private static func executeList(options: ListOptions) -> ExitCode {
        var tasks = TaskRegistry.shared.allTasks()
        if options.includeAll == false {
            tasks = tasks.filter(\.isEnabled)
        }
        if let tag = options.tag {
            let targetTag = ProblemTag(tag)
            tasks = tasks.filter { $0.tags.contains(targetTag) }
        }

        guard !tasks.isEmpty else {
            if let tag = options.tag {
                print("未找到匹配标签：\(tag)")
            } else if options.includeAll == false {
                print("当前没有启用题。")
            } else {
                print("题目列表为空。")
            }
            return .noMatches
        }

        tasks.forEach { task in
            let enabledText = task.isEnabled ? "enabled" : "disabled"
            print("[\(enabledText)] #\(task.id) \(task.title)")
        }
        return .success
    }

    private static func runTask(_ task: any LeetCodeTask, debug: Bool) {
        if debug {
            print("[debug] start #\(task.id)")
        }
        print(task.describe())
        task.run()
        print("---\n")
        if debug {
            print("[debug] end #\(task.id)")
        }
    }

    private static func isIDMatch(taskID: String, input: String) -> Bool {
        let normalizedTaskID = taskID.lowercased()
        let rawInput = input.lowercased()
        let strippedInput = rawInput.hasPrefix("lt") ? String(rawInput.dropFirst(2)) : rawInput
        return normalizedTaskID == rawInput
            || normalizedTaskID == strippedInput
            || "lt\(normalizedTaskID)" == rawInput
    }

    private static func printGeneralHelp() {
        print(
            """
            DailyLeetCodeRunner 用法:
              swift run DailyLeetCodeRunner run [--enabled|--all] [--id <ID> | --tag <TAG>] [--debug]
              swift run DailyLeetCodeRunner list [--enabled|--all] [--tag <TAG>]
              swift run DailyLeetCodeRunner fetch --url <leetcode-url>
              swift run DailyLeetCodeRunner help

            示例:
              swift run DailyLeetCodeRunner run
              swift run DailyLeetCodeRunner run --id LT0088
              swift run DailyLeetCodeRunner run --tag daily
              swift run DailyLeetCodeRunner fetch --url https://leetcode.cn/problems/two-sum/
            """
        )
    }

    private static func fetchMetadata(for urlString: String) async -> ExitCode {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return .usage
        }
        do {
            let client = try ProblemMetadataFetcher.makeClient()
            let details = try await client.fetchProblem(from: url)
            let converter = HtmlToMarkdownConverter()
            let markdown = await details.markdownSummary(using: converter)
            print(markdown)
            return .success
        } catch {
            print("Failed to fetch metadata: \(error)")
            return .failure
        }
    }
}

private struct RunOptions {
    var id: String?
    var tag: String?
    var includeAll: Bool = false
    var debug: Bool = false
}

private struct ListOptions {
    var includeAll: Bool = false
    var tag: String?
}

private enum RunnerCommand {
    case run(RunOptions)
    case fetch(String)
    case list(ListOptions)
    case help
}

private struct CLIError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

private enum HelpRequestedError: Error {
    case runHelp
    case listHelp
    case fetchHelp

    var message: String {
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

private enum ExitCode: Int32 {
    case success = 0
    case failure = 1
    case noMatches = 2
    case usage = 64
}
