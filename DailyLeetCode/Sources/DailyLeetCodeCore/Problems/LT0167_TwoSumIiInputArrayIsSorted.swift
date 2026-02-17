import Foundation

/// # LeetCode 167. Two Sum II - Input Array Is Sorted
/// ## 两数之和 II - 输入有序数组
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/two-sum-ii-input-array-is-sorted/
///
/// ## 描述
/// 给你一个下标从 **1** 开始的整数数组 `numbers` ，该数组已按**非递减顺序排列** ，请你从数组中找出满足相加之和等于目标数 `target` 的两个数。如果设这两个数分别是 `numbers[index<sub>1</sub>]` 和 `numbers[index<sub>2</sub>]` ，则 `1 <= index<sub>1</sub> < index<sub>2</sub> <= numbers.length` 。
///
/// 以长度为 2 的整数数组 `[index<sub>1</sub>, index<sub>2</sub>]` 的形式返回这两个整数的下标 `index<sub>1</sub>` 和 `index<sub>2</sub>`。
///
/// 你可以假设每个输入 **只对应唯一的答案** ，而且你 **不可以** 重复使用相同的元素。
///
/// 你所设计的解决方案必须只使用常量级的额外空间。
///
/// **示例 1：**
///
/// ```
///
/// 输入：numbers = [2,7,11,15], target = 9
/// 输出：[1,2]
/// 解释：2 与 7 之和等于目标数 9 。因此 index1 = 1, index2 = 2 。返回 [1, 2] 。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：numbers = [2,3,4], target = 6
/// 输出：[1,3]
/// 解释：2 与 4 之和等于目标数 6 。因此 index1 = 1, index2 = 3 。返回 [1, 3] 。
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：numbers = [-1,0], target = -1
/// 输出：[1,2]
/// 解释：-1 与 0 之和等于目标数 -1 。因此 index1 = 1, index2 = 2 。返回 [1, 2] 。
/// ```
///
/// **提示：**
///
/// * `2 <= numbers.length <= 3 * 10<sup>4</sup>`
/// * `-1000 <= numbers[i] <= 1000`
/// * `numbers` 按 **非递减顺序** 排列
/// * `-1000 <= target <= 1000`
/// * **仅存在一个有效答案**
public struct LT0167TwoSumIiInputArrayIsSorted: LeetCodeTask {
    public let id = "0167"
    public let title = "两数之和 II - 输入有序数组"
    public let url = URL(string: "https://leetcode.cn/problems/two-sum-ii-input-array-is-sorted/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(twoSum([2,7,11,15], 9))
        print(twoSum([2,3,4], 6))
        print(twoSum([-1,0], -1))
    }

    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0
        var right = numbers.count - 1
        
        while left < right {
            if numbers[left] + numbers[right] > target {
                right -= 1
            }
            
            if numbers[left] + numbers[right] < target {
                left += 1
            }
            
            if numbers[left] + numbers[right] == target {
                break
            }
        }
        
        return [left + 1, right + 1]
    }
}
