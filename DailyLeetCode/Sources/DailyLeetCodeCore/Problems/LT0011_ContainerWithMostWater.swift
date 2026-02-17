import Foundation

/// # LeetCode 11. Container With Most Water
/// ## 盛最多水的容器
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/container-with-most-water/
///
/// ## 描述
/// 给定一个长度为 `n` 的整数数组 `height` 。有 `n` 条垂线，第 `i` 条线的两个端点是 `(i, 0)` 和 `(i, height[i])` 。
///
/// 找出其中的两条线，使得它们与 `x` 轴共同构成的容器可以容纳最多的水。
///
/// 返回容器可以储存的最大水量。
///
/// **说明：**你不能倾斜容器。
///
/// **示例 1：**
///
/// ![](https://aliyun-lc-upload.oss-cn-hangzhou.aliyuncs.com/aliyun-lc-upload/uploads/2018/07/25/question_11.jpg)
///
/// ```
///
/// 输入：[1,8,6,2,5,4,8,3,7]
/// 输出：49 
/// 解释：图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：height = [1,1]
/// 输出：1
/// ```
///
/// **提示：**
///
/// * `n == height.length`
/// * `2 <= n <= 10<sup>5</sup>`
/// * `0 <= height[i] <= 10<sup>4</sup>`
public struct LT0011ContainerWithMostWater: LeetCodeTask {
    public let id = "0011"
    public let title = "盛最多水的容器"
    public let url = URL(string: "https://leetcode.cn/problems/container-with-most-water/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(maxArea([1,8,6,2,5,4,8,3,7]))
        print(maxArea([1,1]))
        print(maxArea([8,7,2,1]))
    }

    func maxArea(_ height: [Int]) -> Int {
        var result = Int.min
        var left = 0
        var right = height.count - 1
        
        while left <= right {
            result = max((right - left) * min(height[left], height[right]), result)
            
            if height[left] <= height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        
        return result
    }
}
