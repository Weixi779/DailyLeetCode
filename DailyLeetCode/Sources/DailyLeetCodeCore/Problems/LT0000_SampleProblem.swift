import Foundation

public struct SampleProblem: LeetCodeTask {
    public let id = "000000"
    public let title = "样例占位题"
    public let url = URL(string: "https://leetcode.cn/problems/example")!
    public let tags: [ProblemTag] = [.custom("demo"), .custom("sample")]

    public init() {}

    public func run() {
        let numbers = [1, 1, 2, 3, 5]
        print("SampleProblem result: \(numbers.reduce(0, +))")
    }
}
