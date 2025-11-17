import Foundation
import LeetCodeAPI

public enum ProblemMetadataFetcher {
    public static func makeClient(envFileRelativePath: String = ".leetcode.env") throws -> LeetCodeClient {
        let fileURL = URL(fileURLWithPath: envFileRelativePath)
        let configuration = try CredentialFileLoader.loadConfiguration(from: fileURL)
        return LeetCodeClient(configuration: configuration)
    }
}
