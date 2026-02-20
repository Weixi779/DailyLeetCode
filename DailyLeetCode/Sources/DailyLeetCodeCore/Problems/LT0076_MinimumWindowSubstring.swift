import Foundation

/// # LeetCode 76. Minimum Window Substring
/// ## 最小覆盖子串
///
/// - 难度: 困难
/// - 链接: https://leetcode.cn/problems/minimum-window-substring/
///
/// ## 描述
/// 给定两个字符串 `s` 和 `t`，长度分别是 `m` 和 `n`，返回 s 中的 **最短窗口 子串**，使得该子串包含 `t` 中的每一个字符（**包括重复字符**）。如果没有这样的子串，返回空字符串 `""`。
///
/// 测试用例保证答案唯一。
///
/// **示例 1：**
///
/// ```
///
/// 输入：s = "ADOBECODEBANC", t = "ABC"
/// 输出："BANC"
/// 解释：最小覆盖子串 "BANC" 包含来自字符串 t 的 'A'、'B' 和 'C'。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：s = "a", t = "a"
/// 输出："a"
/// 解释：整个字符串 s 是最小覆盖子串。
/// ```
///
/// **示例 3:**
///
/// ```
///
/// 输入: s = "a", t = "aa"
/// 输出: ""
/// 解释: t 中两个字符 'a' 均应包含在 s 的子串中，
/// 因此没有符合条件的子字符串，返回空字符串。
/// ```
///
/// **提示：**
///
/// * `m == s.length`
/// * `n == t.length`
/// * `1 <= m, n <= 10<sup>5</sup>`
/// * `s` 和 `t` 由英文字母组成
/// **进阶：**你能设计一个在 `O(m + n)` 时间内解决此问题的算法吗？
public struct LT0076MinimumWindowSubstring: LeetCodeTask {
    public let id = "0076"
    public let title = "最小覆盖子串"
    public let url = URL(string: "https://leetcode.cn/problems/minimum-window-substring/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = true

    public init() {}
    
    public func run() {
        print(minWindow("ADOBECODEBANC", "ABC"))
        print(minWindow("a", "a"))
        print(minWindow("a", "aa"))
    }

    func minWindow(_ s: String, _ t: String) -> String {
        let strs = [Character](s)
        var targetMap = [Character: Int]()
        var charMap = [Character: Int]()
        
        for char in [Character](t) {
            targetMap[char, default: 0] += 1
        }
        
        let targetKinds = targetMap.count
        var validCount = 0
        
        var left = 0
        var bestLeft = 0
        var bestCount = Int.max
        
        for right in strs.indices {
            let str = strs[right]
            charMap[str, default: 0] += 1
            
            if let need = targetMap[str], charMap[str] == need {
                validCount += 1
            }
            
            while validCount == targetKinds {
                let count = right - left + 1
                if count < bestCount {
                    bestCount = count
                    bestLeft = left
                }
                let removeChar = strs[left]
                if let need = targetMap[removeChar], charMap[removeChar] == need {
                    validCount -= 1
                }
                charMap[removeChar, default: 0] -= 1
                left += 1
            }
        }
        
        if bestCount == Int.max { return "" }
        return String(strs[bestLeft..<bestLeft+bestCount])
    }
}
