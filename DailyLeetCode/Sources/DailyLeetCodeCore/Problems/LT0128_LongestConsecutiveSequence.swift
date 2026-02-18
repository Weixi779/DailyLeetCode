import Foundation

/// # LeetCode 128. Longest Consecutive Sequence
/// ## 最长连续序列
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/longest-consecutive-sequence/
///
/// ## 描述
/// 给定一个未排序的整数数组 `nums` ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。
///
/// 请你设计并实现时间复杂度为 `O(n)` 的算法解决此问题。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [100,4,200,1,3,2]
/// 输出：4
/// 解释：最长数字连续序列是 [1, 2, 3, 4]。它的长度为 4。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [0,3,7,2,5,8,4,6,0,1]
/// 输出：9
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：nums = [1,0,1,2]
/// 输出：3
/// ```
///
/// **提示：**
///
/// * `0 <= nums.length <= 10<sup>5</sup>`
/// * `-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup>`
public struct LT0128LongestConsecutiveSequence: LeetCodeTask {
    public let id = "0128"
    public let title = "最长连续序列"
    public let url = URL(string: "https://leetcode.cn/problems/longest-consecutive-sequence/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    func longestConsecutive(_ nums: [Int]) -> Int {
        let set = Set(nums)
        var result = 0
        
        for x in set {
            if set.contains(x-1) { continue } // 每次找到最小的那个开头 如果自己不是就跳过
            
            var current = x
            var count = 1
            
            while set.contains(current + 1) {
                current += 1
                count += 1
            }
            
            result = max(result, count)
        }
        
        return result
    }
}
