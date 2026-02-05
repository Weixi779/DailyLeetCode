import Foundation

/// # LeetCode 45. Jump Game II
/// ## 跳跃游戏 II
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/jump-game-ii/
///
/// ## 描述
/// 给定一个长度为 `n` 的 **0 索引**整数数组 `nums`。初始位置在下标 0。
///
/// 每个元素 `nums[i]` 表示从索引 `i` 向后跳转的最大长度。换句话说，如果你在索引 `i` 处，你可以跳转到任意 `(i + j)` 处：
///
/// * `0 <= j <= nums[i]` 且
/// * `i + j < n`
///
/// 返回到达 `n - 1` 的最小跳跃次数。测试用例保证可以到达 `n - 1`。
///
/// **示例 1:**
///
/// ```
///
/// 输入: nums = [2,3,1,1,4]
/// 输出: 2
/// 解释: 跳到最后一个位置的最小跳跃数是 2。
///      从下标为 0 跳到下标为 1 的位置，跳 1 步，然后跳 3 步到达数组的最后一个位置。
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入: nums = [2,3,0,1,4]
/// 输出: 2
/// ```
///
/// **提示:**
///
/// * `1 <= nums.length <= 10<sup>4</sup>`
/// * `0 <= nums[i] <= 1000`
/// * 题目保证可以到达 `n - 1`
public struct LT0045JumpGameIi: LeetCodeTask {
    public let id = "0045"
    public let title = "跳跃游戏 II"
    public let url = URL(string: "https://leetcode.cn/problems/jump-game-ii/")!
    public let tags: [ProblemTag] = []

    public init() {}

    public func run() {
        print([2,3,1,1,4])
    }
    
    // 非常牛逼的一道题
    // 他的思路从 dp 找某个最优解 改称为 区间的最优解
    // 不过思想应该是先从dp开始 多次循环之后发现不行了之后再去修改
    func jump(_ nums: [Int]) -> Int {
        var step = 0
        var currentEnd = 0
        var farthest = 0
        
        for i in 0..<nums.count - 1 {
            farthest = max(farthest, nums[i] + i)
            
            if currentEnd == i {
                step += 1
                currentEnd = farthest
            }
        }
        
        return step
    }
}
