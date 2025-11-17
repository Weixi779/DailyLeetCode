import DailyLeetCodeCore
import Foundation

@MainActor
@main
struct DailyLeetCodeRunner {
    static func main() {
        TaskCatalog.bootstrap().forEach { TaskRegistry.shared.register($0) }

        let args = CommandLine.arguments.dropFirst()
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
        print("Running all registered tasks (\(TaskRegistry.shared.allTasks().count))\n")
        TaskRegistry.shared.allTasks().forEach(runTask)
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
}
