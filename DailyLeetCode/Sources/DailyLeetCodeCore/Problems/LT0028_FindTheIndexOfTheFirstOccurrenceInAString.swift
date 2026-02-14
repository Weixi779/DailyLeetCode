import Foundation

/// # LeetCode 28. Find the Index of the First Occurrence in a String
/// ## 找出字符串中第一个匹配项的下标
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/
///
/// ## 描述
/// 给你两个字符串 `haystack` 和 `needle` ，请你在 `haystack` 字符串中找出 `needle` 字符串的第一个匹配项的下标（下标从 0 开始）。如果 `needle` 不是 `haystack` 的一部分，则返回 `-1` 。
///
/// **示例 1：**
///
/// ```
///
/// 输入：haystack = "sadbutsad", needle = "sad"
/// 输出：0
/// 解释："sad" 在下标 0 和 6 处匹配。
/// 第一个匹配项的下标是 0 ，所以返回 0 。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：haystack = "leetcode", needle = "leeto"
/// 输出：-1
/// 解释："leeto" 没有在 "leetcode" 中出现，所以返回 -1 。
/// ```
///
/// **提示：**
///
/// * `1 <= haystack.length, needle.length <= 10<sup>4</sup>`
/// * `haystack` 和 `needle` 仅由小写英文字符组成
public struct LT0028FindTheIndexOfTheFirstOccurrenceInAString: LeetCodeTask {
    public let id = "0028"
    public let title = "找出字符串中第一个匹配项的下标"
    public let url = URL(string: "https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = true

    public init() {}
    
    public func run() {
        print(strStr("sadbutsad", "sad"))
        print(strStr("sadbutsad", "but"))
        print(strStr("leetcode", "leeto"))
    }

    func strStr(_ haystack: String, _ needle: String) -> Int {
        var haystack = haystack
        var count = 0
        while haystack.count >= needle.count {
            
            if !haystack.hasPrefix(needle) {
                haystack.removeFirst()
                count += 1
            } else {
                return count
            }
        }
        
        return -1
    }
}
