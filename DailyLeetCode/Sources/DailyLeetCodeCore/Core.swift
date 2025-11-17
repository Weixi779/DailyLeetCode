import Foundation

public enum ProblemCategory: Equatable {
    case daily(date: DateComponents)
    case topic(name: String)
}

public protocol LeetCodeTask {
    var id: String { get }
    var title: String { get }
    var url: URL { get }
    var category: ProblemCategory { get }
    func run()
}

public extension LeetCodeTask {
    func describe() -> String {
        "[#\(id)] \(title) -> \(url.absoluteString)"
    }
}

public protocol DailyTask: LeetCodeTask {
    var date: DateComponents { get }
}

public extension DailyTask {
    var category: ProblemCategory { .daily(date: date) }
}

public protocol TopicTask: LeetCodeTask {
    var topicName: String { get }
}

public extension TopicTask {
    var category: ProblemCategory { .topic(name: topicName) }
}

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

    public func tasks(in category: ProblemCategory) -> [any LeetCodeTask] {
        queue.sync {
            storage.filter { $0.category == category }
        }
    }
}

public enum TaskCatalog {
    public static func bootstrap() -> [any LeetCodeTask] {
        [SampleDailyTask(), SampleTopicTask()]
    }
}
