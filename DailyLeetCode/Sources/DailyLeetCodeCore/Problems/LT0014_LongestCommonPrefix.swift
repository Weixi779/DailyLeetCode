import Foundation

/// # LeetCode 14. Longest Common Prefix
/// ## 最长公共前缀
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/longest-common-prefix/
///
/// ## 描述
/// 编写一个函数来查找字符串数组中的最长公共前缀。
///
/// 如果不存在公共前缀，返回空字符串 `""`。
///
/// **示例 1：**
///
/// ```
///
/// 输入：strs = ["flower","flow","flight"]
/// 输出："fl"
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：strs = ["dog","racecar","car"]
/// 输出：""
/// 解释：输入不存在公共前缀。
/// ```
///
/// **提示：**
///
/// * `1 <= strs.length <= 200`
/// * `0 <= strs[i].length <= 200`
/// * `strs[i]` 如果非空，则仅由小写英文字母组成
public struct LT0014LongestCommonPrefix: LeetCodeTask {
    public let id = "0014"
    public let title = "最长公共前缀"
    public let url = URL(string: "https://leetcode.cn/problems/longest-common-prefix/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(longestCommonPrefix(["flower","flow","flight"]))
        print(longestCommonPrefix(["dog","racecar","car"]))
    }
    
    func allEqual(_ chars: [Character]) -> Bool {
        let target = chars.first!
        return chars.allSatisfy { $0 == target }
    }

    func longestCommonPrefix(_ strs: [String]) -> String {
        guard strs.count > 0 else { return "" }
        var count = 0
        let minCount = strs.map { $0.count }.min()!
        for i in 0..<minCount {
            let currentIndexChars = strs.map { [Character]($0)[i] }
            if allEqual(currentIndexChars) {
                count += 1
            } else {
                break
            }
        }
        
        return String(strs[0].prefix(count))
    }
}
