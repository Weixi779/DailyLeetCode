import Foundation

/// # LeetCode 58. Length of Last Word
/// ## 最后一个单词的长度
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/length-of-last-word/
///
/// ## 描述
/// 给你一个字符串 `s`，由若干单词组成，单词前后用一些空格字符隔开。返回字符串中 **最后一个** 单词的长度。
///
/// **单词** 是指仅由字母组成、不包含任何空格字符的最大子字符串。
///
/// **示例 1：**
///
/// ```
///
/// 输入：s = "Hello World"
/// 输出：5
/// 解释：最后一个单词是“World”，长度为 5。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：s = "   fly me   to   the moon  "
/// 输出：4
/// 解释：最后一个单词是“moon”，长度为 4。
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：s = "luffy is still joyboy"
/// 输出：6
/// 解释：最后一个单词是长度为 6 的“joyboy”。
/// ```
///
/// **提示：**
///
/// * `1 <= s.length <= 10<sup>4</sup>`
/// * `s` 仅有英文字母和空格 `' '` 组成
/// * `s` 中至少存在一个单词
public struct LT0058LengthOfLastWord: LeetCodeTask {
    public let id = "0058"
    public let title = "最后一个单词的长度"
    public let url = URL(string: "https://leetcode.cn/problems/length-of-last-word/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(lengthOfLastWord("Hello World"))
        print(lengthOfLastWord("   fly me   to   the moon  "))
        print(lengthOfLastWord("luffy is still joyboy"))
    }

    func lengthOfLastWord(_ s: String) -> Int {
        var result = ""
        var isSpaced = false
        for char in s {
            if char != " " {
                result = isSpaced ? String(char) : result + String(char)
            }
            
            isSpaced = char == " "
        }
        
        return result.count
    }
}
