import Foundation

/// # LeetCode 209. Minimum Size Subarray Sum
/// ## 长度最小的子数组
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/minimum-size-subarray-sum/
///
/// ## 描述
/// 给定一个含有 `n` 个正整数的数组和一个正整数 `target` **。**
///
/// 找出该数组中满足其总和大于等于 `target` 的长度最小的 **子数组** `[nums<sub>l</sub>, nums<sub>l+1</sub>, ..., nums<sub>r-1</sub>, nums<sub>r</sub>]` ，并返回其长度**。**如果不存在符合条件的子数组，返回 `0` 。
///
/// **示例 1：**
///
/// ```
///
/// 输入：target = 7, nums = [2,3,1,2,4,3]
/// 输出：2
/// 解释：子数组 [4,3] 是该条件下的长度最小的子数组。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：target = 4, nums = [1,4,4]
/// 输出：1
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：target = 11, nums = [1,1,1,1,1,1,1,1]
/// 输出：0
/// ```
///
/// **提示：**
///
/// * `1 <= target <= 10<sup>9</sup>`
/// * `1 <= nums.length <= 10<sup>5</sup>`
/// * `1 <= nums[i] <= 10<sup>4</sup>`
///
/// **进阶：**
///
/// * 如果你已经实现 `O(n)` 时间复杂度的解法, 请尝试设计一个 `O(n log(n))` 时间复杂度的解法。
public struct LT0209MinimumSizeSubarraySum: LeetCodeTask {
    public let id = "0209"
    public let title = "长度最小的子数组"
    public let url = URL(string: "https://leetcode.cn/problems/minimum-size-subarray-sum/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(minSubArrayLen(7, [2,3,1,2,4,3]))
    }
    
    // 2
    // 2 3
    // 2 3 1
    // 2 3 1 2
    // 3 1 2
    // 3 1 2 4
    // 1 2 4
    // 2 4
    // 2 4 3
    // 4 3

    func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
        var left = 0
        var sum = 0
        var result = Int.max

        for i in nums.indices {
            sum += nums[i]

            while sum >= target {
                result = min(result, i - left + 1)
                sum -= nums[left]
                left += 1
            }
        }

        return result == Int.max ? 0 : result
    }
}
