import Foundation

public struct ProblemTag: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }

    public var description: String { rawValue }
}

public protocol LeetCodeTask {
    var id: String { get }
    var title: String { get }
    var url: URL { get }
    var tags: [ProblemTag] { get }
    func run()
}

public extension LeetCodeTask {
    func describe() -> String {
        let tagsJoined = tags.map(\.rawValue).joined(separator: ", ")
        let tagText = tagsJoined.isEmpty ? "" : " [tags: \(tagsJoined)]"
        return "[#\(id)] \(title) -> \(url.absoluteString)\(tagText)"
    }

    func run() {}
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

    public func tasks(withTag tag: ProblemTag) -> [any LeetCodeTask] {
        queue.sync {
            storage.filter { task in
                task.tags.contains { $0.rawValue.caseInsensitiveCompare(tag.rawValue) == .orderedSame }
            }
        }
    }
}

@MainActor
public enum TaskCatalog {
    public static func bootstrap() -> [any LeetCodeTask] {
        ProblemCatalog.all
    }
}
