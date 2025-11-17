import Foundation
import Testing
@testable import DailyLeetCodeCore

@Test("Sample daily metadata validation")
func sampleDailyTaskMetadata() {
    let task = SampleDailyTask()
    #expect(task.id == "000000")
    #expect(task.describe().contains("样例占位题"))
    switch task.category {
    case .daily(let date):
        #expect(date.year == 2024)
    default:
        Issue.record("SampleDailyTask 应归类为 daily")
    }
}
