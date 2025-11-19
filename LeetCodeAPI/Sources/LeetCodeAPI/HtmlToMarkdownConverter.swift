import Demark
import Foundation

public struct HtmlToMarkdownConverter: Sendable {
    private let options: DemarkOptions

    public init(options: DemarkOptions = DemarkOptions(engine: .htmlToMd)) {
        self.options = options
    }

    public func convert(html: String) async throws -> String {
        try await HtmlToMarkdownConverter.convertOnMain(html: html, options: options)
    }

    @MainActor
    private static func convertOnMain(html: String, options: DemarkOptions) async throws -> String {
        let demark = Demark()
        return try await demark.convertToMarkdown(html, options: options)
    }
}
