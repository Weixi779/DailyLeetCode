import Foundation

@MainActor
public enum ProblemCatalog {
    public static let all: [any LeetCodeTask] = [
        SampleProblem(),
        LT1071BinaryPrefixDivisibleBy5(),
        LT1694MakeSumDivisibleByP(),
        LT0303RangeSumQueryImmutable(),
        LT0088MergeSortedArray(),
        LT0027RemoveElement(),
        LT0026RemoveDuplicatesFromSortedArray(),
        LT0080RemoveDuplicatesFromSortedArrayIi(),
        LT0169MajorityElement(),
        LT3704CountPartitionsWithEvenSumDifference(),
        LT1630CountOddNumbersInAnIntervalRange(),
        LT0189RotateArray(),
        LT0121BestTimeToBuyAndSellStock(),
        LT0122BestTimeToBuyAndSellStockIi(),
        LT0055JumpGame(),
        LT0045JumpGameIi(),
        LT0274HIndex(),
        LT0380InsertDeleteGetrandomO1(),
        LT0238ProductOfArrayExceptSelf(),
        LT0134GasStation(),

    ]
}
