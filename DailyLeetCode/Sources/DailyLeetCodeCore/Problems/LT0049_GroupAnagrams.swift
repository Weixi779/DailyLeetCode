import Foundation

/// # LeetCode 49. Group Anagrams
/// ## 字母异位词分组
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/group-anagrams/
///
/// ## 描述
/// 给你一个字符串数组，请你将 字母异位词 组合在一起。可以按任意顺序返回结果列表。
///
/// **示例 1:**
///
/// **输入:** strs = \["eat", "tea", "tan", "ate", "nat", "bat"\]
///
/// **输出:** [["bat"],["nat","tan"],["ate","eat","tea"]]
///
/// **解释：**
///
/// * 在 strs 中没有字符串可以通过重新排列来形成 `"bat"`。
/// * 字符串 `"nat"` 和 `"tan"` 是字母异位词，因为它们可以重新排列以形成彼此。
/// * 字符串 `"ate"` ，`"eat"` 和 `"tea"` 是字母异位词，因为它们可以重新排列以形成彼此。
///
/// **示例 2:**
///
/// **输入:** strs = \[""\]
///
/// **输出:** [[""]]
///
/// **示例 3:**
///
/// **输入:** strs = \["a"\]
///
/// **输出:** [["a"]]
///
/// **提示：**
///
/// * `1 <= strs.length <= 10<sup>4</sup>`
/// * `0 <= strs[i].length <= 100`
/// * `strs[i]` 仅包含小写字母
public struct LT0049GroupAnagrams: LeetCodeTask {
    public let id = "0049"
    public let title = "字母异位词分组"
    public let url = URL(string: "https://leetcode.cn/problems/group-anagrams/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var map = [[Character]: [String]]()
        
        for str in strs {
            let word = [Character](str).sorted()
            map[word, default: []] += [str]
        }
        
        return map.values.map { $0 }
    }
}
