import Demark
import Foundation

public struct ProblemDetails: Sendable {
    public let id: String
    public let slug: String
    public let title: String
    public let translatedTitle: String?
    public let content: String?
    public let translatedContent: String?
    public let difficulty: String?
    public let exampleTestCases: [String]

    public init(
        id: String,
        slug: String,
        title: String,
        translatedTitle: String?,
        content: String?,
        translatedContent: String?,
        difficulty: String?,
        exampleTestCases: [String]
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.translatedTitle = translatedTitle
        self.content = content
        self.translatedContent = translatedContent
        self.difficulty = difficulty
        self.exampleTestCases = exampleTestCases
    }

    public func markdownSummary(using converter: HtmlToMarkdownConverter = HtmlToMarkdownConverter()) async -> String {
        var sections = [String]()
        var heading = "# LeetCode \(id). \(title)"
        if let translatedTitle, !translatedTitle.isEmpty {
            heading += "\n## \(translatedTitle)"
        }
        sections.append(heading)

        var metadata = [String]()
        if let difficulty, !difficulty.isEmpty {
            metadata.append("- Difficulty: \(difficulty)")
        }
        metadata.append("- Link: https://leetcode.cn/problems/\(slug)/")
        sections.append(metadata.joined(separator: "\n"))

        let cnMarkdown = await markdown(from: translatedContent, using: converter)
        let enMarkdown = await markdown(from: content, using: converter)

        if let cnMarkdown {
            sections.append("## 描述\n\(cnMarkdown)")
        }

        let shouldIncludeEnglish = content != nil && (translatedContent == nil || translatedContent != content)
        if let enMarkdown, shouldIncludeEnglish || cnMarkdown == nil {
            let heading = cnMarkdown == nil ? "## Description" : "## Description (EN)"
            sections.append("\(heading)\n\(enMarkdown)")
        }

        return sections.joined(separator: "\n\n")
    }

    private func markdown(from html: String?, using converter: HtmlToMarkdownConverter) async -> String? {
        guard let html, !html.isEmpty else { return nil }
        return try? await converter.convert(html: html)
    }
}

public enum LeetCodeAPIError: Error, CustomStringConvertible {
    case invalidSlug
    case invalidResponse
    case graphQLErrors([String])
    case credentialsMissing(String)

    public var description: String {
        switch self {
        case .invalidSlug:
            return "无法从 URL 中解析题目 slug"
        case .invalidResponse:
            return "接口返回结构异常"
        case .graphQLErrors(let messages):
            return messages.joined(separator: "\n")
        case .credentialsMissing(let key):
            return "缺少必要的配置: \(key)"
        }
    }
}

public struct LeetCodeClientConfiguration: Sendable {
    public let endpoint: URL
    public let cookieHeaderValue: String
    public let csrfToken: String
    public let referer: URL

    public init(endpoint: URL, cookieHeaderValue: String, csrfToken: String, referer: URL = URL(string: "https://leetcode.cn")!) {
        self.endpoint = endpoint
        self.cookieHeaderValue = cookieHeaderValue
        self.csrfToken = csrfToken
        self.referer = referer
    }
}

public actor LeetCodeClient {
    public let configuration: LeetCodeClientConfiguration
    private let urlSession: URLSession

    public init(configuration: LeetCodeClientConfiguration, urlSession: URLSession = .shared) {
        self.configuration = configuration
        self.urlSession = urlSession
    }

    public func fetchProblem(from url: URL) async throws -> ProblemDetails {
        let slug = try Self.slug(from: url)
        return try await fetchProblem(slug: slug)
    }

    public func fetchProblem(slug: String) async throws -> ProblemDetails {
        let requestBody = GraphQLPayload.operation(slug: slug)
        var request = URLRequest(url: configuration.endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(configuration.csrfToken, forHTTPHeaderField: "x-csrftoken")
        request.addValue(configuration.cookieHeaderValue, forHTTPHeaderField: "Cookie")
        request.addValue(configuration.referer.absoluteString, forHTTPHeaderField: "Referer")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw LeetCodeAPIError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(GraphQLResponse.self, from: data)
        if let errors = decoded.errors, !errors.isEmpty {
            throw LeetCodeAPIError.graphQLErrors(errors.map { $0.message })
        }
        guard let question = decoded.data?.question else {
            throw LeetCodeAPIError.invalidResponse
        }
        let examples = question.exampleTestcases?
            .split(separator: "\n")
            .map { String($0) }
            .filter { !$0.isEmpty } ?? []
        return ProblemDetails(
            id: question.questionId,
            slug: question.titleSlug,
            title: question.title,
            translatedTitle: question.translatedTitle,
            content: question.content,
            translatedContent: question.translatedContent,
            difficulty: question.difficulty,
            exampleTestCases: examples
        )
    }

    public static func slug(from url: URL) throws -> String {
        let components = url.pathComponents
        guard let index = components.firstIndex(of: "problems"), index + 1 < components.count else {
            throw LeetCodeAPIError.invalidSlug
        }
        return components[index + 1].trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}

public struct CredentialFileLoader {
    public static func loadConfiguration(from fileURL: URL) throws -> LeetCodeClientConfiguration {
        let content = try String(contentsOf: fileURL)
        var values: [String: String] = [:]
        content
            .split(whereSeparator: { $0.isNewline })
            .forEach { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty, !trimmed.hasPrefix("#") else { return }
                let parts = trimmed.split(separator: "=", maxSplits: 1).map(String.init)
                guard parts.count == 2 else { return }
                values[parts[0]] = parts[1]
            }
        guard let session = values["LEETCODE_SESSION"], !session.isEmpty else {
            throw LeetCodeAPIError.credentialsMissing("LEETCODE_SESSION")
        }
        guard let csrf = values["LEETCODE_CSRF"], !csrf.isEmpty else {
            throw LeetCodeAPIError.credentialsMissing("LEETCODE_CSRF")
        }
        let endpointString = values["LEETCODE_ENDPOINT"] ?? "https://leetcode.cn/graphql/"
        guard let endpoint = URL(string: endpointString) else {
            throw LeetCodeAPIError.credentialsMissing("LEETCODE_ENDPOINT")
        }
        let cookie = "LEETCODE_SESSION=\(session); csrftoken=\(csrf)"
        return LeetCodeClientConfiguration(endpoint: endpoint, cookieHeaderValue: cookie, csrfToken: csrf)
    }
}

private enum GraphQLPayload {
    struct Operation: Encodable {
        let operationName: String
        let variables: Variables
        let query: String
    }

    struct Variables: Encodable {
        let titleSlug: String
    }

    static func operation(slug: String) -> Operation {
        Operation(
            operationName: "questionData",
            variables: Variables(titleSlug: slug),
            query: queryString
        )
    }

    private static let queryString = """
    query questionData($titleSlug: String!) {
      question(titleSlug: $titleSlug) {
        questionId
        difficulty
        title
        translatedTitle
        titleSlug
        content
        translatedContent
        exampleTestcases
      }
    }
    """
}

private struct GraphQLResponse: Decodable {
    let data: DataField?
    let errors: [GraphQLError]?

    struct DataField: Decodable {
        let question: Question?
    }

    struct Question: Decodable {
        let questionId: String
        let difficulty: String?
        let title: String
        let translatedTitle: String?
        let titleSlug: String
        let content: String?
        let translatedContent: String?
        let exampleTestcases: String?
    }
}

private struct GraphQLError: Decodable {
    let message: String
}
