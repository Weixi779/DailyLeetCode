import Foundation

/// # LeetCode 88. Merge Sorted Array
/// ## 合并两个有序数组
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/merge-sorted-array/
///
/// ## 描述
/// 给你两个按 **非递减顺序** 排列的整数数组 `nums1` 和 `nums2`，另有两个整数 `m` 和 `n` ，分别表示 `nums1` 和 `nums2` 中的元素数目。
///
/// 请你 **合并** `nums2` 到 `nums1` 中，使合并后的数组同样按 **非递减顺序** 排列。
///
/// **注意：**最终，合并后数组不应由函数返回，而是存储在数组 `nums1` 中。为了应对这种情况，`nums1` 的初始长度为 `m + n`，其中前 `m` 个元素表示应合并的元素，后 `n` 个元素为 `0` ，应忽略。`nums2` 的长度为 `n` 。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
/// 输出：[1,2,2,3,5,6]
/// 解释：需要合并 [1,2,3] 和 [2,5,6] 。
/// 合并结果是 [1,2,2,3,5,6] ，其中斜体加粗标注的为 nums1 中的元素。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums1 = [1], m = 1, nums2 = [], n = 0
/// 输出：[1]
/// 解释：需要合并 [1] 和 [] 。
/// 合并结果是 [1] 。
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：nums1 = [0], m = 0, nums2 = [1], n = 1
/// 输出：[1]
/// 解释：需要合并的数组是 [] 和 [1] 。
/// 合并结果是 [1] 。
/// 注意，因为 m = 0 ，所以 nums1 中没有元素。nums1 中仅存的 0 仅仅是为了确保合并结果可以顺利存放到 nums1 中。
/// ```
///
/// **提示：**
///
/// * `nums1.length == m + n`
/// * `nums2.length == n`
/// * `0 <= m, n <= 200`
/// * `1 <= m + n <= 200`
/// * `-10<sup>9</sup> <= nums1[i], nums2[j] <= 10<sup>9</sup>`
///
/// **进阶：**你可以设计实现一个时间复杂度为 `O(m + n)` 的算法解决此问题吗？
public struct LT0088MergeSortedArray: LeetCodeTask {
    public let id = "0088"
    public let title = "合并两个有序数组"
    public let url = URL(string: "https://leetcode.cn/problems/merge-sorted-array/")!
    public let tags: [ProblemTag] = []

    public init() {}

    public func run() {
        var test1 = [1,2,3,0,0,0]
        merge(&test1, 3, [2,5,6], 3)
        var test2 = [1]
        merge(&test2, 1, [], 0)
    }
    
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var result = [Int]()
        
        var numbers1 = nums1.prefix(m).map { $0 }
        var numbers2 = nums2
        
        while !numbers1.isEmpty && !numbers2.isEmpty {
            if let first1 = numbers1.first, let first2 = numbers2.first {
                if first1 < first2 {
                    result.append(numbers1.removeFirst())
                } else {
                    result.append(numbers2.removeFirst())
                }
            }
        }
        
        if numbers1.isEmpty { result.append(contentsOf: numbers2) }
        if numbers2.isEmpty { result.append(contentsOf: numbers1) }
        
        nums1 = result
    }
}
