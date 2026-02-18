import Foundation

/// # LeetCode 290. Word Pattern
/// ## 单词规律
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/word-pattern/
///
/// ## 描述
/// 给定一种规律 `pattern` 和一个字符串 `s` ，判断 `s` 是否遵循相同的规律。
///
/// 这里的 **遵循** 指完全匹配，例如， `pattern` 里的每个字母和字符串 `s` 中的每个非空单词之间存在着双向连接的对应规律。具体来说：
///
/// * `pattern` 中的每个字母都 **恰好** 映射到 `s` 中的一个唯一单词。
/// * `s` 中的每个唯一单词都 **恰好** 映射到 `pattern` 中的一个字母。
/// * 没有两个字母映射到同一个单词，也没有两个单词映射到同一个字母。
///
/// **示例1:**
///
/// ```
///
/// 输入: pattern = "abba", s = "dog cat cat dog"
/// 输出: true
/// ```
///
/// **示例 2:**
///
/// ```
///
/// 输入:pattern = "abba", s = "dog cat cat fish"
/// 输出: false
/// ```
///
/// **示例 3:**
///
/// ```
///
/// 输入: pattern = "aaaa", s = "dog cat cat dog"
/// 输出: false
/// ```
///
/// **提示:**
///
/// * `1 <= pattern.length <= 300`
/// * `pattern` 只包含小写英文字母
/// * `1 <= s.length <= 3000`
/// * `s` 只包含小写英文字母和 `' '`
/// * `s`**不包含** 任何前导或尾随对空格
/// * `s` 中每个单词都被 **单个空格** 分隔
public struct LT0290WordPattern: LeetCodeTask {
    public let id = "0290"
    public let title = "单词规律"
    public let url = URL(string: "https://leetcode.cn/problems/word-pattern/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    func wordPattern(_ pattern: String, _ s: String) -> Bool {
        let pattern = [Character](pattern)
        let words = s.split(separator: " ")
        
        guard words.count == pattern.count else { return false }
        
        var charMap = [Character: String]()
        var wordMap = [String: Character]()
        
        for (i, word) in words.enumerated() {
            let word = String(word)
            let char = pattern[i]
            
            if let v = charMap[char], word != v { return false }
            if let c = wordMap[word], char != c { return false }
            
            charMap[char] = String(word)
            wordMap[word] = char
        }
        
        return true
    }
}
