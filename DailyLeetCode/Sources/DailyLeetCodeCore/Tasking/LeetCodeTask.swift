import Foundation

public protocol LeetCodeTask {
    var id: String { get }
    var title: String { get }
    var url: URL { get }
    var tags: [ProblemTag] { get }
    var isEnabled: Bool { get }
    func run()
}

public extension LeetCodeTask {
    func describe() -> String {
        let tagsJoined = tags.map(\.description).joined(separator: ", ")
        let tagText = tagsJoined.isEmpty ? "" : " [tags: \(tagsJoined)]"
        return "[#\(id)] \(title) -> \(url.absoluteString)\(tagText)"
    }

    var isEnabled: Bool { false }

    func run() {}
}
