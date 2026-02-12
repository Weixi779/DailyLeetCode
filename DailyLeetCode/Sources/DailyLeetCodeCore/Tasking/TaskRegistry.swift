import Foundation

@MainActor
public final class TaskRegistry {
    public static let shared = TaskRegistry()
    private var storage: [any LeetCodeTask] = []
    private let queue = DispatchQueue(label: "dev.dailyleetcode.registry", attributes: .concurrent)

    private init() {}

    public func register(_ task: any LeetCodeTask) {
        queue.sync(flags: .barrier) {
            storage.append(task)
        }
    }

    public func allTasks() -> [any LeetCodeTask] {
        queue.sync { storage }
    }

    public func tasks(withTag tag: ProblemTag) -> [any LeetCodeTask] {
        queue.sync {
            storage.filter { task in
                task.tags.contains { $0 == tag }
            }
        }
    }
}
