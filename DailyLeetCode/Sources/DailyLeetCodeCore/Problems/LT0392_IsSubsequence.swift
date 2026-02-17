import Foundation

/// # LeetCode 392. Is Subsequence
/// ## 判断子序列
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/is-subsequence/
///
/// ## 描述
/// 给定字符串 **s** 和 **t** ，判断 **s** 是否为 **t** 的子序列。
///
/// 字符串的一个子序列是原始字符串删除一些（也可以不删除）字符而不改变剩余字符相对位置形成的新字符串。（例如，`"ace"`是`"abcde"`的一个子序列，而`"aec"`不是）。
///
/// **进阶：**
///
/// 如果有大量输入的 S，称作 S1, S2, ... , Sk 其中 k >= 10亿，你需要依次检查它们是否为 T 的子序列。在这种情况下，你会怎样改变代码？
///
/// **致谢：**
///
/// 特别感谢 [@pbrother](https://leetcode.com/pbrother/)添加此问题并且创建所有测试用例。
///
/// **示例 1：**
///
/// ```
///
/// 输入：s = "abc", t = "ahbgdc"
/// 输出：true
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：s = "axc", t = "ahbgdc"
/// 输出：false
/// ```
///
/// **提示：**
///
/// * `0 <= s.length <= 100`
/// * `0 <= t.length <= 10^4`
/// * 两个字符串都只由小写字符组成。
public struct LT0392IsSubsequence: LeetCodeTask {
    public let id = "0392"
    public let title = "判断子序列"
    public let url = URL(string: "https://leetcode.cn/problems/is-subsequence/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(isSubsequence("abc", "ahbgdc"))
        print(isSubsequence("axc", "ahbgdc"))
    }

    func isSubsequence(_ s: String, _ t: String) -> Bool {
        let targetChars = [Character](s)
        let chars = [Character](t)
        var total = 0
        
        for i in chars {
            // 已满足 不再循环
            if total >= targetChars.count { break }
            
            if i == targetChars[total] {
                total += 1
            }
        }
        
        return total == targetChars.count
    }
}
