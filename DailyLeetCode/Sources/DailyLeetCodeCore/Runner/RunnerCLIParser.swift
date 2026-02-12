import Foundation

public enum RunnerCLIParser {
    public static func parse(arguments: [String]) throws -> RunnerCommand {
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
                throw RunnerCLIError("未知命令或参数：\(first)")
            }
            throw RunnerCLIError("旧用法已移除，请使用 `run --id \(first)`")
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
                throw RunnerHelpRequestedError.runHelp
            case "--id":
                guard index + 1 < args.count else { throw RunnerCLIError("--id 缺少值") }
                options.id = args[index + 1]
                index += 1
            case "--tag":
                guard index + 1 < args.count else { throw RunnerCLIError("--tag 缺少值") }
                options.tag = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--id=") {
                    options.id = String(arg.dropFirst(5))
                } else if arg.hasPrefix("--tag=") {
                    options.tag = String(arg.dropFirst(6))
                } else {
                    throw RunnerCLIError("run 不支持参数：\(arg)")
                }
            }
            index += 1
        }

        if options.id != nil, options.tag != nil {
            throw RunnerCLIError("--id 与 --tag 不能同时使用")
        }
        if options.includeAll, options.tag != nil {
            throw RunnerCLIError("--all 与 --tag 不能同时使用")
        }
        return options
    }

    private static func parseFetchURL(from args: [String]) throws -> String {
        guard !args.isEmpty else {
            throw RunnerCLIError("fetch 需要 --url 参数")
        }

        var urlValue: String?
        var index = 0
        while index < args.count {
            let arg = args[index]
            switch arg {
            case "--help", "-h":
                throw RunnerHelpRequestedError.fetchHelp
            case "--url":
                guard index + 1 < args.count else { throw RunnerCLIError("--url 缺少值") }
                urlValue = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--url=") {
                    urlValue = String(arg.dropFirst(6))
                } else {
                    throw RunnerCLIError("fetch 不支持参数：\(arg)")
                }
            }
            index += 1
        }

        guard let urlValue, !urlValue.isEmpty else {
            throw RunnerCLIError("fetch 需要 --url 参数")
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
                throw RunnerHelpRequestedError.listHelp
            case "--tag":
                guard index + 1 < args.count else { throw RunnerCLIError("--tag 缺少值") }
                options.tag = args[index + 1]
                index += 1
            default:
                if arg.hasPrefix("--tag=") {
                    options.tag = String(arg.dropFirst(6))
                } else {
                    throw RunnerCLIError("list 不支持参数：\(arg)")
                }
            }
            index += 1
        }
        return options
    }
}
