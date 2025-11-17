import Foundation

public struct SampleTopicTask: TopicTask {
    public let id = "topic-000"
    public let title = "双指针示例"
    public let url = URL(string: "https://leetcode.cn/problems/two-sum")!
    public let topicName = "TwoPointers"

    public init() {}

    public func run() {
        let nums = [2, 7, 11, 15]
        let target = 9
        var indexMap: [Int: Int] = [:]
        for (index, value) in nums.enumerated() {
            if let other = indexMap[target - value] {
                print("SampleTopicTask result: \(other), \(index)")
                return
            }
            indexMap[value] = index
        }
        print("SampleTopicTask result: not found")
    }
}
