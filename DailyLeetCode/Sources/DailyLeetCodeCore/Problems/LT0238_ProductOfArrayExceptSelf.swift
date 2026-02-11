import Foundation

/// # LeetCode 238. Product of Array Except Self
/// ## 除了自身以外数组的乘积
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/product-of-array-except-self/
///
/// ## 描述
/// 给你一个整数数组 `nums`，返回 数组 `answer` ，其中 `answer[i]` 等于 `nums` 中除了 `nums[i]` 之外其余各元素的乘积 。
///
/// 题目数据 **保证** 数组 `nums`之中任意元素的全部前缀元素和后缀的乘积都在 **32 位** 整数范围内。
///
/// 请 **不要使用除法，**且在 `O(n)` 时间复杂度内完成此题。
///
/// **示例 1:**
///
/// ```
///
/// 输入: nums = [1,2,3,4]
/// 输出: [24,12,8,6]
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入: nums = [-1,1,0,-3,3]
/// 输出: [0,0,9,0,0]
/// ```
///
/// **提示：**
///
/// * `2 <= nums.length <= 10<sup>5</sup>`
/// * `-30 <= nums[i] <= 30`
/// * 输入 **保证** 数组 `answer[i]` 在 **32 位** 整数范围内
///
/// **进阶：**你可以在 `O(1)` 的额外空间复杂度内完成这个题目吗？（ 出于对空间复杂度分析的目的，输出数组 **不被视为** 额外空间。）
public struct LT0238ProductOfArrayExceptSelf: LeetCodeTask {
    public let id = "0238"
    public let title = "除了自身以外数组的乘积"
    public let url = URL(string: "https://leetcode.cn/problems/product-of-array-except-self/")!
    public let tags: [ProblemTag] = []

    public init() {}
    
    public func run() {
        print(productExceptSelf([1,2,3,4]))
        print(productExceptSelf([-1,1,0,-3,3]))
    }

    func productExceptSelf(_ nums: [Int]) -> [Int] {
        var prefix: [Int] = Array(repeating: 1, count: nums.count)
        var subfix: [Int] = Array(repeating: 1, count: nums.count)
        
        for i in 0..<nums.count-1 {
            prefix[i+1] = nums[i] * prefix[i]
        }
        
        for i in (1..<nums.count).reversed() {
            subfix[i-1] = nums[i] * subfix[i]
        }

        var result: [Int] = Array(repeating: 1, count: nums.count)
        for i in prefix.indices {
            result[i] = prefix[i] * subfix[i]
        }
        
        return result
    }
}
