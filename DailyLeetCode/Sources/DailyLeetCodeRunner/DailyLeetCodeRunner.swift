import DailyLeetCodeCore
import LeetCodeAPI
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

        if let tagArg = args.first(where: { $0.hasPrefix("--tag=") }) {
            let value = tagArg.replacingOccurrences(of: "--tag=", with: "")
            run(tagFilter: value)
            return
        } else if let tagIndex = args.firstIndex(of: "--tag"), tagIndex + 1 < args.count {
            run(tagFilter: args[tagIndex + 1])
            return
        }

        if let id = args.first, !id.hasPrefix("--") {
            run(idFilter: id)
        } else {
            runAll()
        }
    }

    private static func runAll() {
        let tasks = TaskRegistry.shared.allTasks()
        guard !tasks.isEmpty else { return }
        tasks.forEach(runTask)
    }

    private static func run(idFilter: String) {
        let matches = TaskRegistry.shared
            .allTasks()
            .filter { $0.id.lowercased() == idFilter.lowercased() }
        guard !matches.isEmpty else { return }
        matches.forEach(runTask)
    }

    private static func run(tagFilter: String) {
        let lower = tagFilter.lowercased()
        let matches = TaskRegistry.shared
            .allTasks()
            .filter { task in
                task.tags.contains { $0.rawValue.lowercased() == lower }
            }
        guard !matches.isEmpty else { return }
        matches.forEach(runTask)
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
//            dump(details)
            let converter = HtmlToMarkdownConverter()
            let markdown = await details.markdownSummary(using: converter)
            print(markdown)
        } catch {
            print("Failed to fetch metadata: \(error)")
        }
    }
}
