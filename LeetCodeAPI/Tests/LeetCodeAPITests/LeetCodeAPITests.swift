import XCTest
@testable import LeetCodeAPI

final class LeetCodeAPITests: XCTestCase {
    func testSlugParsing() throws {
        let url = try XCTUnwrap(URL(string: "https://leetcode.cn/problems/two-sum/description/"))
        let slug = try LeetCodeClient.slug(from: url)
        XCTAssertEqual(slug, "two-sum")
    }

    func testCredentialLoader() throws {
        let temp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("leetcode.env")
        let sample = """
        # comment
        LEETCODE_SESSION=session_token
        LEETCODE_CSRF=csrf_token
        LEETCODE_ENDPOINT=https://leetcode.com/graphql/
        """
        try sample.write(to: temp, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: temp) }

        let config = try CredentialFileLoader.loadConfiguration(from: temp)
        XCTAssertEqual(config.endpoint.absoluteString, "https://leetcode.com/graphql/")
        XCTAssertTrue(config.cookieHeaderValue.contains("session_token"))
        XCTAssertEqual(config.csrfToken, "csrf_token")
    }
}
