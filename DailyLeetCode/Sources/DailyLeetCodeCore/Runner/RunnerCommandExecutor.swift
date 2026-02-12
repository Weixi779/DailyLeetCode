import Foundation
import LeetCodeAPI

@MainActor
public enum RunnerCommandExecutor {
    public static func execute(_ command: RunnerCommand) async -> RunnerExitCode {
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

    private static func executeRun(options: RunOptions) -> RunnerExitCode {
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

    private static func executeList(options: ListOptions) -> RunnerExitCode {
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

    private static func fetchMetadata(for urlString: String) async -> RunnerExitCode {
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
