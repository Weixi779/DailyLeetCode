import Foundation

/// # LeetCode 383. Ransom Note
/// ## 赎金信
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/ransom-note/
///
/// ## 描述
/// 给你两个字符串：`ransomNote` 和 `magazine` ，判断 `ransomNote` 能不能由 `magazine` 里面的字符构成。
///
/// 如果可以，返回 `true` ；否则返回 `false` 。
///
/// `magazine` 中的每个字符只能在 `ransomNote` 中使用一次。
///
/// **示例 1：**
///
/// ```
///
/// 输入：ransomNote = "a", magazine = "b"
/// 输出：false
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：ransomNote = "aa", magazine = "ab"
/// 输出：false
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：ransomNote = "aa", magazine = "aab"
/// 输出：true
/// ```
///
/// **提示：**
///
/// * `1 <= ransomNote.length, magazine.length <= 10<sup>5</sup>`
/// * `ransomNote` 和 `magazine` 由小写英文字母组成
public struct LT0383RansomNote: LeetCodeTask {
    public let id = "0383"
    public let title = "赎金信"
    public let url = URL(string: "https://leetcode.cn/problems/ransom-note/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    // TODO: 编写题解代码与本地调试入口
}