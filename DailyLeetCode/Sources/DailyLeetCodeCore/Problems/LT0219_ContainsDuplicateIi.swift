import Foundation

/// # LeetCode 219. Contains Duplicate II
/// ## 存在重复元素 II
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/contains-duplicate-ii/
///
/// ## 描述
/// 给你一个整数数组 `nums` 和一个整数 `k` ，判断数组中是否存在两个 **不同的索引** `i` 和 `j` ，满足 `nums[i] == nums[j]` 且 `abs(i - j) <= k` 。如果存在，返回 `true` ；否则，返回 `false` 。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [1,2,3,1], k = 3
/// 输出：true
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [1,0,1,1], k = 1
/// 输出：true
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：nums = [1,2,3,1,2,3], k = 2
/// 输出：false
/// ```
///
/// **提示：**
///
/// * `1 <= nums.length <= 10<sup>5</sup>`
/// * `-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup>`
/// * `0 <= k <= 10<sup>5</sup>`
public struct LT0219ContainsDuplicateIi: LeetCodeTask {
    public let id = "0219"
    public let title = "存在重复元素 II"
    public let url = URL(string: "https://leetcode.cn/problems/contains-duplicate-ii/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(containsNearbyDuplicate([1,2,3,1,2,3], 2))
    }

    func containsNearbyDuplicate(_ nums: [Int], _ k: Int) -> Bool {
        var map = [Int: Int]() // value index
        
        for (i, value) in nums.enumerated() {
            if let lastIndex = map[value], i - lastIndex <= k {
                return true
            }
            
            map[value] = i
        }
                
        return false
    }
}
