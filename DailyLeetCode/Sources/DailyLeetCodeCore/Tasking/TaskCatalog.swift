import Foundation

@MainActor
public enum TaskCatalog {
    public static func bootstrap() -> [any LeetCodeTask] {
        ProblemCatalog.all
    }
}
