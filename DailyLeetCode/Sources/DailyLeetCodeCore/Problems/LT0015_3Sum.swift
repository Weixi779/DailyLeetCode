import Foundation

/// # LeetCode 15. 3Sum
/// ## 三数之和
///
/// - 难度: 中等
/// - 链接: https://leetcode.cn/problems/3sum/
///
/// ## 描述
/// 给你一个整数数组 `nums` ，判断是否存在三元组 `[nums[i], nums[j], nums[k]]` 满足 `i != j`、`i != k` 且 `j != k` ，同时还满足 `nums[i] + nums[j] + nums[k] == 0` 。请你返回所有和为 `0` 且不重复的三元组。
///
/// **注意：**答案中不可以包含重复的三元组。
///
/// **示例 1：**
///
/// ```
///
/// 输入：nums = [-1,0,1,2,-1,-4]
/// 输出：[[-1,-1,2],[-1,0,1]]
/// 解释：
/// nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0 。
/// nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0 。
/// nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0 。
/// 不同的三元组是 [-1,0,1] 和 [-1,-1,2] 。
/// 注意，输出的顺序和三元组的顺序并不重要。
/// ```
///
/// **示例 2：**
///
/// ```
///
/// 输入：nums = [0,1,1]
/// 输出：[]
/// 解释：唯一可能的三元组和不为 0 。
/// ```
///
/// **示例 3：**
///
/// ```
///
/// 输入：nums = [0,0,0]
/// 输出：[[0,0,0]]
/// 解释：唯一可能的三元组和为 0 。
/// ```
///
/// **提示：**
///
/// * `3 <= nums.length <= 3000`
/// * `-10<sup>5</sup> <= nums[i] <= 10<sup>5</sup>`
/*
 - MARK: 解题思路:
    这道题困扰了我一些时间, 乍看能想到的就是通解 但是会 N3的循环 之前也能过 但是好像添加了一些边缘case 导致不可以了
    正确思路 这道题考的也是双指针, 当我们确认好第一个数字的位置后 之后就是把 这个道题 转化为了 有序 2sum
    但是注意要处理一些边缘case
 */
public struct LT00153Sum: LeetCodeTask {
    public let id = "0015"
    public let title = "三数之和"
    public let url = URL(string: "https://leetcode.cn/problems/3sum/")!
    public let tags: [ProblemTag] = []
    public let isEnabled = false

    public init() {}

    public func run() {
//        print(threeSum([-1,0,1,2,-1,-4]))
//        print(threeSum([0,1,1]))
//        print(threeSum([0,0,0]))
        print(threeSum([-100,-70,-60,110,120,130,160]))
    }
    
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let nums = nums.sorted()
        var result = [[Int]]()
        
        for i in nums.indices {
            if nums[i] > 0 { break } // for this case alway > 0, impossible equal 0
            if i > 0 && nums[i] == nums[i-1] { continue } // 去重左侧
            
            var left = i + 1
            var right = nums.count - 1
            
            while left < right {
                let sum = nums[i] + nums[left] + nums[right]
                
                if sum == 0 {
                    result.append([nums[i], nums[left], nums[right]])
                    left += 1
                    right -= 1
                    
                    while left < right || nums[left] == nums[left+1] { left += 1 }
                    while left < right || nums[right] == nums[right-1] { right -= 1 }
                } else if sum < 0 {
                    left += 1
                } else {
                    right -= 1
                }
            }
        }
        
        return result
    }
    
    func threeSumSetVersion(_ nums: [Int]) -> [[Int]] { // set 写法 一定能AC 推荐 之后再想优化的事情
        let nums = nums.sorted()
        var ansSet = Set<[Int]>()  // 用 Set 去重三元组

        for i in 0..<nums.count {
            var left = i + 1
            var right = nums.count - 1

            while left < right {
                let sum = nums[i] + nums[left] + nums[right]

                if sum == 0 {
                    ansSet.insert([nums[i], nums[left], nums[right]])
                    left += 1
                    right -= 1
                } else if sum < 0 {
                    left += 1
                } else {
                    right -= 1
                }
            }
        }

        return Array(ansSet)
    }

}
