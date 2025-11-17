import Foundation

public struct SampleDailyTask: DailyTask {
    public let id = "000000"
    public let title = "样例占位题"
    public let url = URL(string: "https://leetcode.cn/problems/example")!
    public let date = DateComponents(year: 2024, month: 7, day: 1)

    public init() {}

    public func run() {
        let numbers = [1, 1, 2, 3, 5]
        print("SampleDailyTask result: \(numbers.reduce(0, +))")
    }
}
