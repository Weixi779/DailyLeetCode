import Foundation
import Testing
@testable import DailyLeetCodeCore

@Test("Sample problem metadata validation")
func sampleProblemMetadata() {
    let task = SampleProblem()
    #expect(task.id == "000000")
    #expect(task.describe().contains("样例占位题"))
    #expect(task.tags.contains("demo"))
}
