import Foundation

/// # LeetCode 42. Trapping Rain Water
/// ## 接雨水
///
/// - 难度: 困难
/// - 链接: https://leetcode.cn/problems/trapping-rain-water/
///
/// ## 描述
/// 给定 `n` 个非负整数表示每个宽度为 `1` 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。
///
/// **示例 1：**
///
/// ![](https://assets.leetcode.cn/aliyun-lc-upload/uploads/2018/10/22/rainwatertrap.png)
///
/// ```
///
/// 输入：height = [0,1,0,2,1,0,1,3,2,1,2,1]
/// 输出：6
/// 解释：上面是由数组 [0,1,0,2,1,0,1,3,2,1,2,1] 表示的高度图，在这种情况下，可以接 6 个单位的雨水（蓝色部分表示雨水）。 
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：height = [4,2,0,3,2,5]
/// 输出：9
/// ```
///
/// **提示：**
///
/// * `n == height.length`
/// * `1 <= n <= 2 * 10<sup>4</sup>`
/// * `0 <= height[i] <= 10<sup>5</sup>`
public struct LT0042TrappingRainWater: LeetCodeTask {
    public let id = "0042"
    public let title = "接雨水"
    public let url = URL(string: "https://leetcode.cn/problems/trapping-rain-water/")!
    public let tags: [ProblemTag] = []

    public init() {}

    func trap(_ height: [Int]) -> Int {
        var water = 0
        
        var maxLeft: [Int] = [Int](repeating: 0, count: height.count)
        for i in maxLeft.indices {
            if i == 0 {
                maxLeft[i] = height[i]
            } else {
                maxLeft[i] = max(maxLeft[i-1], height[i])
            }
        }
        
        var maxRight: [Int] = [Int](repeating: 0, count: height.count)
        for i in maxLeft.indices.reversed() {
            if i == height.count - 1 {
                maxRight[i] = height[i]
            } else {
                maxRight[i] = max(height[i], maxRight[i+1])
            }
        }
        
        for index in height.indices {
            water += min(maxLeft[index], maxRight[index]) - height[index]
        }
        
        return water
    }
}
