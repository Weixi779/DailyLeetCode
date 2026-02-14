import Foundation

/// # LeetCode 6. Zigzag Conversion
/// ## Z 字形变换
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/zigzag-conversion/
///
/// ## 描述
/// 将一个给定字符串 `s` 根据给定的行数 `numRows` ，以从上往下、从左到右进行 Z 字形排列。
///
/// 比如输入字符串为 `"PAYPALISHIRING"` 行数为 `3` 时，排列如下：
///
/// ```
///
/// P   A   H   N
/// A P L S I I G
/// Y   I   R
/// ```
///
/// 之后，你的输出需要从左往右逐行读取，产生出一个新的字符串，比如：`"PAHNAPLSIIGYIR"`。
///
/// 请你实现这个将字符串进行指定行数变换的函数：
///
/// ```
///
/// string convert(string s, int numRows);
/// ```
///
/// **示例 1：**
///
/// ```
///
/// 输入：s = "PAYPALISHIRING", numRows = 3
/// 输出："PAHNAPLSIIGYIR"
/// ```
/// **示例 2：**
///
/// ```
///
/// 输入：s = "PAYPALISHIRING", numRows = 4
/// 输出："PINALSIGYAHRPI"
/// 解释：
/// P     I    N
/// A   L S  I G
/// Y A   H R
/// P     I
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：s = "A", numRows = 1
/// 输出："A"
/// ```
///
/// **提示：**
///
/// * `1 <= s.length <= 1000`
/// * `s` 由英文字母（小写和大写）、`','` 和 `'.'` 组成
/// * `1 <= numRows <= 1000`
public struct LT0006ZigzagConversion: LeetCodeTask {
    public let id = "0006"
    public let title = "Z 字形变换"
    public let url = URL(string: "https://leetcode.cn/problems/zigzag-conversion/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(convert("PAYPALISHIRING", 3))
        print(convert("PAYPALISHIRING", 4))
        print(convert("A", 1))
    }

    func convert(_ s: String, _ numRows: Int) -> String {
        if numRows == 1 || s.count <= numRows { return s }
        let chars = [Character](s)
        var zArrays: [[Character]] = [[Character]](repeating: [Character](), count: numRows)
        let cycle = 2 * numRows - 2

        for i in chars.indices {
            let k = i % cycle
            let row = min(k, cycle - k)

            zArrays[row].append(chars[i])
        }
        
        return zArrays.reduce("", +)
    }
}
