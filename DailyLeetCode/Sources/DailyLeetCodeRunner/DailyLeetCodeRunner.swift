import DailyLeetCodeCore
import Foundation

@MainActor
@main
struct DailyLeetCodeRunner {
    static func main() async {
        TaskCatalog.bootstrap().forEach { TaskRegistry.shared.register($0) }

        let args = Array(CommandLine.arguments.dropFirst())
        if let fetchArg = args.first(where: { $0.hasPrefix("--fetch-url=") }) {
            let value = fetchArg.replacingOccurrences(of: "--fetch-url=", with: "")
            await fetchMetadata(for: value)
            return
        } else if let fetchIndex = args.firstIndex(of: "--fetch"), fetchIndex + 1 < args.count {
            await fetchMetadata(for: args[fetchIndex + 1])
            return
        }

        if let categoryArg = args.first(where: { $0.hasPrefix("--category=") }) {
            let value = categoryArg.replacingOccurrences(of: "--category=", with: "")
            run(categoryFilter: value)
        } else if let id = args.first {
            run(idFilter: id)
        } else {
            runAll()
        }
    }

    private static func runAll() {
        let tasks = TaskRegistry.shared.allTasks()
        print("Running all registered tasks (\(tasks.count))\n")
        tasks.forEach(runTask)
    }

    private static func run(idFilter: String) {
        let matches = TaskRegistry.shared
            .allTasks()
            .filter { $0.id.lowercased() == idFilter.lowercased() }
        if matches.isEmpty {
            print("No task found for id \(idFilter)")
        } else {
            matches.forEach(runTask)
        }
    }

    private static func run(categoryFilter: String) {
        let lower = categoryFilter.lowercased()
        let matches = TaskRegistry.shared.allTasks().filter { task in
            switch task.category {
            case .daily:
                return lower == "daily"
            case .topic(let name):
                return lower == "topic" || lower == name.lowercased()
            }
        }
        if matches.isEmpty {
            print("No task found for category filter \(categoryFilter)")
        } else {
            matches.forEach(runTask)
        }
    }

    private static func runTask(_ task: any LeetCodeTask) {
        print(task.describe())
        task.run()
        print("---\n")
    }

    private static func fetchMetadata(for urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        do {
            let client = try ProblemMetadataFetcher.makeClient()
            let details = try await client.fetchProblem(from: url)
            print("Fetched metadata:")
            print("ID: \(details.id)")
            print("Slug: \(details.slug)")
            print("Title: \(details.title)")
            if let translated = details.translatedTitle {
                print("Title (CN): \(translated)")
            }
            print("URL: https://leetcode.cn/problems/\(details.slug)/")
            if !details.exampleTestCases.isEmpty {
                print("Example Testcases:")
                for (index, example) in details.exampleTestCases.enumerated() {
                    print("[\(index + 1)] \(example)")
                }
            }
        } catch {
            print("Failed to fetch metadata: \(error)")
        }
    }
}
