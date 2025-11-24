import Foundation

/// # LeetCode 1071. Binary Prefix Divisible By 5
/// ## 可被 5 整除的二进制前缀
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/binary-prefix-divisible-by-5/
///
/// ## 描述
/// 给定一个二进制数组 `nums` ( **索引从0开始** )。
///
/// 我们将`x<sub>i</sub>` 定义为其二进制表示形式为子数组 `nums[0..i]` (从最高有效位到最低有效位)。
///
/// * 例如，如果 `nums =[1,0,1]` ，那么 `x<sub>0</sub> = 1`, `x<sub>1</sub> = 2`, 和 `x<sub>2</sub> = 5`。
///
/// 返回布尔值列表 `answer`，只有当 `x<sub>i</sub>` 可以被 `5` 整除时，答案 `answer[i]` 为 `true`，否则为 `false`。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [0,1,1]
/// 输出：[true,false,false]
/// 解释：
/// 输入数字为 0, 01, 011；也就是十进制中的 0, 1, 3 。只有第一个数可以被 5 整除，因此 answer[0] 为 true 。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [1,1,1]
/// 输出：[false,false,false]
/// ```
///
/// **提示：**
///
/// * `1 <= nums.length <= 10<sup>5</sup>`
/// * `nums[i]` 仅为 `0` 或 `1`
public struct LT1071BinaryPrefixDivisibleBy5: LeetCodeTask {
    public let id = "1071"
    public let title = "可被 5 整除的二进制前缀"
    public let url = URL(string: "https://leetcode.cn/problems/binary-prefix-divisible-by-5/")!
    public let tags: [ProblemTag] = []

    public init() {}
    
    public func run() {
        print(prefixesDivBy5([0,1,1]))
        print(prefixesDivBy5([1,1,1]))
        print(prefixesDivBy5([1,0,1,1,1,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,1,0,0,0,1,0,0,1,1,1,1,1,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,1,1,0,0,1,0]))
    }
    
    func prefixesDivBy5(_ nums: [Int]) -> [Bool] {
        var result: [Bool] = [Bool](repeating: false, count: nums.count)
        
        var current: Int = 0
        for (index, number) in nums.enumerated() {
            current = (current << 1 | number) % 5
            result[index] = (current == 0)
        }
        
        return result
    }
}
