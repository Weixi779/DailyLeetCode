import Foundation

/// # LeetCode 202. Happy Number
/// ## 快乐数
///
/// - 难度: 简单
/// - 链接: https://leetcode.cn/problems/happy-number/
///
/// ## 描述
/// 编写一个算法来判断一个数 `n` 是不是快乐数。
///
/// **「快乐数」** 定义为：
///
/// * 对于一个正整数，每一次将该数替换为它每个位置上的数字的平方和。
/// * 然后重复这个过程直到这个数变为 1，也可能是 **无限循环** 但始终变不到 1。
/// * 如果这个过程 **结果为** 1，那么这个数就是快乐数。
///
/// 如果 `n` 是 *快乐数* 就返回 `true` ；不是，则返回 `false` 。
///
/// **示例 1：**
///
/// ```
///
/// 输入：n = 19
/// 输出：true
/// 解释：
/// 12 + 92 = 82
/// 82 + 22 = 68
/// 62 + 82 = 100
/// 12 + 02 + 02 = 1
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：n = 2
/// 输出：false
/// ```
///
/// **提示：**
///
/// * `1 <= n <= 2<sup>31</sup> - 1`
public struct LT0202HappyNumber: LeetCodeTask {
    public let id = "0202"
    public let title = "快乐数"
    public let url = URL(string: "https://leetcode.cn/problems/happy-number/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}
    
    public func run() {
        print(isHappy(19))
    }
    
    private func nextNumber(_ num: Int) -> Int {
        var num = num
        var result = 0
        
        while num > 0 {
            let peerNumber = num % 10
            result += peerNumber * peerNumber
            num /= 10
        }
        
        return result
    }
 
    func isHappy(_ n: Int) -> Bool {
        var slow = n
        var fast = nextNumber(n)
        
        while fast != 1, slow != fast {
            slow = nextNumber(slow)
            fast = nextNumber(nextNumber(fast))
        }
        
        return fast == 1
    }
}
