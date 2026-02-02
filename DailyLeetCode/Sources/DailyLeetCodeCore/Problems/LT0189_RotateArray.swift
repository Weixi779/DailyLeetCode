import Foundation

/// # LeetCode 189. Rotate Array
/// ## 轮转数组
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/rotate-array/
///
/// ## 描述
/// 给定一个整数数组 `nums`，将数组中的元素向右轮转 `k` 个位置，其中 `k` 是非负数。
///
/// **示例 1:**
///
/// ```
///
/// 输入: nums = [1,2,3,4,5,6,7], k = 3
/// 输出: [5,6,7,1,2,3,4]
/// 解释:
/// 向右轮转 1 步: [7,1,2,3,4,5,6]
/// 向右轮转 2 步: [6,7,1,2,3,4,5]
/// 向右轮转 3 步: [5,6,7,1,2,3,4]
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入：nums = [-1,-100,3,99], k = 2
/// 输出：[3,99,-1,-100]
/// 解释: 
/// 向右轮转 1 步: [99,-1,-100,3]
/// 向右轮转 2 步: [3,99,-1,-100]
/// ```
///
/// **提示：**
///
/// * `1 <= nums.length <= 10<sup>5</sup>`
/// * `-2<sup>31</sup> <= nums[i] <= 2<sup>31</sup> - 1`
/// * `0 <= k <= 10<sup>5</sup>`
///
/// **进阶：**
///
/// * 尽可能想出更多的解决方案，至少有 **三种** 不同的方法可以解决这个问题。
/// * 你可以使用空间复杂度为 `O(1)` 的 **原地** 算法解决这个问题吗？
public struct LT0189RotateArray: LeetCodeTask {
    public let id = "0189"
    public let title = "轮转数组"
    public let url = URL(string: "https://leetcode.cn/problems/rotate-array/")!
    public let tags: [ProblemTag] = []

    public init() {}

    public func run() {
        var test = [1,2,3,4,5,6,7]
        rotate(&test, 3)
        print(test)
    }
    
    func rotate(_ nums: inout [Int], _ k: Int) {
        let count = nums.count
        
        guard count > 1 else { return }

        let point = k % nums.count

        nums.reverse()
        nums[0..<point].reverse()
        nums[point..<count].reverse()
    }
}
