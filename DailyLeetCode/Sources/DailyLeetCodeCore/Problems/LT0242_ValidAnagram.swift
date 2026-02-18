import Foundation

/// # LeetCode 242. Valid Anagram
/// ## 有效的字母异位词
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/valid-anagram/
///
/// ## 描述
/// 给定两个字符串 `s` 和 `t` ，编写一个函数来判断 `t` 是否是 `s` 的 字母异位词。
///
/// **示例 1:**
///
/// ```
///
/// 输入: s = "anagram", t = "nagaram"
/// 输出: true
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入: s = "rat", t = "car"
/// 输出: false
/// ```
///
/// **提示:**
///
/// * `1 <= s.length, t.length <= 5 * 10<sup>4</sup>`
/// * `s` 和 `t` 仅包含小写字母
///
/// **进阶:** 如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？
public struct LT0242ValidAnagram: LeetCodeTask {
    public let id = "0242"
    public let title = "有效的字母异位词"
    public let url = URL(string: "https://leetcode.cn/problems/valid-anagram/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    private func wordMap(_ str: String) -> [Character: Int] {
        var map = [Character: Int]()
        str.forEach {  map[$0, default: 0] += 1 }
        return map
    }

    func isAnagram(_ s: String, _ t: String) -> Bool {
        var map = wordMap(s)
        for char in t {
            map[char, default: 0] -= 1
        }
        
        return map.allSatisfy { $0.value == 0 }
    }
}
