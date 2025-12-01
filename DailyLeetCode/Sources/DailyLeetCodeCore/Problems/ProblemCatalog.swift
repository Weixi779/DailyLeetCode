import Foundation

@MainActor
public enum ProblemCatalog {
    public static let all: [any LeetCodeTask] = [
        SampleProblem(),
        LT1071BinaryPrefixDivisibleBy5(),
        LT1694MakeSumDivisibleByP(),
        LT0303RangeSumQueryImmutable(),
        LT0088MergeSortedArray(),
        LT0027RemoveElement(),

    ]
}
