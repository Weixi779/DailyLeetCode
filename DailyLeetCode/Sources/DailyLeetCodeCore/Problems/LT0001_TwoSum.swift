import Foundation

/// # LeetCode 1. Two Sum
/// ## 两数之和
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/two-sum/
///
/// ## 描述
/// 给定一个整数数组 `nums` 和一个整数目标值 `target`，请你在该数组中找出 **和为目标值** *`target`* 的那 **两个** 整数，并返回它们的数组下标。
///
/// 你可以假设每种输入只会对应一个答案，并且你不能使用两次相同的元素。
///
/// 你可以按任意顺序返回答案。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [2,7,11,15], target = 9
/// 输出：[0,1]
/// 解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [3,2,4], target = 6
/// 输出：[1,2]
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：nums = [3,3], target = 6
/// 输出：[0,1]
/// ```
///
/// **提示：**
///
/// * `2 <= nums.length <= 10<sup>4</sup>`
/// * `-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup>`
/// * `-10<sup>9</sup> <= target <= 10<sup>9</sup>`
/// * **只会存在一个有效答案**
///
/// **进阶：**你可以想出一个时间复杂度小于 `O(n<sup>2</sup>)` 的算法吗？
public struct LT0001TwoSum: LeetCodeTask {
    public let id = "0001"
    public let title = "两数之和"
    public let url = URL(string: "https://leetcode.cn/problems/two-sum/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(twoSum([3,2,4], 6))
    }

    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map = [Int: Int]() // value index
        
        for i in nums.indices {
            if let index = map[target - nums[i]] {
                return [i, index]
            } else {
                map[nums[i]] = i
            }
        }
        
        return []
    }
}
