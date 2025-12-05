import Foundation

/// # LeetCode 169. Majority Element
/// ## 多数元素
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/majority-element/
///
/// ## 描述
/// 给定一个大小为 `n` 的数组 `nums` ，返回其中的多数元素。多数元素是指在数组中出现次数 **大于** `⌊ n/2 ⌋` 的元素。
///
/// 你可以假设数组是非空的，并且给定的数组总是存在多数元素。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [3,2,3]
/// 输出：3
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [2,2,1,1,1,2,2]
/// 输出：2
/// ```
/// **提示：**
///
/// * `n == nums.length`
/// * `1 <= n <= 5 * 10<sup>4</sup>`
/// * `-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup>`
/// * 输入保证数组中一定有一个多数元素。
///
/// **进阶：**尝试设计时间复杂度为 O(n)、空间复杂度为 O(1) 的算法解决此问题。
public struct LT0169MajorityElement: LeetCodeTask {
    public let id = "0169"
    public let title = "多数元素"
    public let url = URL(string: "https://leetcode.cn/problems/majority-element/")!
    public let tags: [ProblemTag] = []

    public init() {}

    func majorityElement(_ nums: [Int]) -> Int {
        var hashMap: [Int: Int] = [:]
        
        for num in nums {
            hashMap[num] = (hashMap[num] ?? 0) + 1
        }
        
        var result = 0
        var maxCount = Int.min
        
        for (key, count) in hashMap {
            if count > maxCount {
                maxCount = count
                result = key
            }
        }
        
        return result
    }
}
