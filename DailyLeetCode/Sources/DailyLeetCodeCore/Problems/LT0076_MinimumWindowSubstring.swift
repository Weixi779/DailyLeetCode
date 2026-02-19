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
    
    private func isSameWord(_ targetMap: [Character: Int], _ charMap: [Character: Int]) -> Bool {
        for (key, value) in targetMap {
            if (charMap[key] ?? 0) < value { return false }
        }
        
        return true
    }

    func minWindow(_ s: String, _ t: String) -> String {
        let strs = [Character](s)
        var targetMap = [Character: Int]()
        var result: [Character]? = nil
        var chars = [Character]()
        var charMap = [Character: Int]()
        
        for char in [Character](t) {
            targetMap[char, default: 0] += 1
        }
        
        for str in strs {
            chars.append(str)
            charMap[str, default: 0] += 1
            
            while isSameWord(targetMap, charMap) {
                result = (result?.count ?? Int.max) <= chars.count ? result : chars
                let removeChar = chars.removeFirst()
                charMap[removeChar, default: 0] -= 1
            }
        }
        
        return String(chars)
    }
}
