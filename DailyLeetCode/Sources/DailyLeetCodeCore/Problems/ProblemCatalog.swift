import Foundation

@MainActor
public enum ProblemCatalog {
    public static let all: [any LeetCodeTask] = [
        SampleProblem(),
        LT1071BinaryPrefixDivisibleBy5(),

    ]
}
