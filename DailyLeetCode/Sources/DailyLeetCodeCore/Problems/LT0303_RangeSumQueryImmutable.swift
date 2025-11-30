import Foundation

/// # LeetCode 303. Range Sum Query - Immutable
/// ## 区域和检索 - 数组不可变
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/range-sum-query-immutable/
///
/// ## 描述
/// 给定一个整数数组 `nums`，处理以下类型的多个查询:
///
/// 1. 计算索引 `left` 和 `right` （包含 `left` 和 `right`）之间的 `nums` 元素的 **和** ，其中 `left <= right`
///
/// 实现 `NumArray` 类：
///
/// * `NumArray(int[] nums)` 使用数组 `nums` 初始化对象
/// * `int sumRange(int i, int j)` 返回数组 `nums` 中索引 `left` 和 `right` 之间的元素的 **总和** ，包含 `left` 和 `right` 两点（也就是 `nums[left] + nums[left + 1] + ... + nums[right]` )
///
/// **示例 1：**
///
/// ```
///
/// 输入：
/// ["NumArray", "sumRange", "sumRange", "sumRange"]
/// [[[-2, 0, 3, -5, 2, -1]], [0, 2], [2, 5], [0, 5]]
/// 输出：
/// [null, 1, -1, -3]
///
/// 解释：
/// NumArray numArray = new NumArray([-2, 0, 3, -5, 2, -1]);
/// numArray.sumRange(0, 2); // return 1 ((-2) + 0 + 3)
/// numArray.sumRange(2, 5); // return -1 (3 + (-5) + 2 + (-1)) 
/// numArray.sumRange(0, 5); // return -3 ((-2) + 0 + 3 + (-5) + 2 + (-1))
/// ```
///
/// **提示：**
///
/// * `1 <= nums.length <= 10<sup>4</sup>`
/// * `-10<sup>5</sup> <= nums[i] <= 10<sup>5</sup>`
/// * `0 <= i <= j < nums.length`
/// * 最多调用 `10<sup>4</sup>` 次 `sumRange` 方法
public struct LT0303RangeSumQueryImmutable: LeetCodeTask {
    public let id = "0303"
    public let title = "区域和检索 - 数组不可变"
    public let url = URL(string: "https://leetcode.cn/problems/range-sum-query-immutable/")!
    public let tags: [ProblemTag] = []

    public init() {}

    class NumArray {
        
        var prefixSums: [Int] = []

        init(_ nums: [Int]) {
            var sum = 0
            for num in nums {
                sum += num
                prefixSums.append(sum)
            }
        }
        
        func sumRange(_ left: Int, _ right: Int) -> Int {
            let leftSum = left == 0 ? 0 : prefixSums[left-1]
            let rightSum = prefixSums[right]
            return rightSum - leftSum
        }
    }
}
