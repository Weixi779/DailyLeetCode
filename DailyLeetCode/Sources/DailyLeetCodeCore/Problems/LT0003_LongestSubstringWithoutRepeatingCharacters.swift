import Foundation

/// # LeetCode 3. Longest Substring Without Repeating Characters
/// ## 无重复字符的最长子串
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/longest-substring-without-repeating-characters/
///
/// ## 描述
/// 给定一个字符串 `s` ，请你找出其中不含有重复字符的 **最长 子串** 的长度。
///
/// **示例 1:**
///
/// ```
///
/// 输入: s = "abcabcbb"
/// 输出: 3 
/// 解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。注意 "bca" 和 "cab" 也是正确答案。
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入: s = "bbbbb"
/// 输出: 1
/// 解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
/// ```
///
/// **示例 3:**
///
/// ```
///
/// 输入: s = "pwwkew"
/// 输出: 3
/// 解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
///      请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
/// ```
///
/// **提示：**
///
/// * `0 <= s.length <= 5 * 10<sup>4</sup>`
/// * `s` 由英文字母、数字、符号和空格组成
public struct LT0003LongestSubstringWithoutRepeatingCharacters: LeetCodeTask {
    public let id = "0003"
    public let title = "无重复字符的最长子串"
    public let url = URL(string: "https://leetcode.cn/problems/longest-substring-without-repeating-characters/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    func lengthOfLongestSubstring(_ s: String) -> Int {
        let chars = [Character](s)
        var result = Int.min
        var left = 0
        var temp = [Character]()
        
        for i in chars.indices {
            while temp.contains(chars[i]) {
                left += 1
                temp.removeFirst()
            }
            temp.append(chars[i])
            result = max(result, temp.count)
        }
        
        return max(result, 0)
    }
}
