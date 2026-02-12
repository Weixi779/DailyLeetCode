import Foundation
import LeetCodeAPI

public enum ProblemTemplateRenderer {
    public static func render(details: ProblemDetails, tags: [String]) async -> (typeName: String, fileName: String, content: String) {
        let normalized = normalizedID(details.id)
        let typeSuffix = makeTypeSuffix(from: details.slug)
        let typeName = "LT\(normalized)\(typeSuffix)"
        let fileName = "LT\(normalized)_\(typeSuffix).swift"

        let markdown = await details.markdownSummary()
        let docComment = docComment(from: markdown)
        let displayTitle = details.translatedTitle?.isEmpty == false ? details.translatedTitle! : details.title
        let tagsLiteral = tagLiteral(from: tags)

        let content = """
        import Foundation

        \(docComment)
        public struct \(typeName): LeetCodeTask {
            public let id = \"\(normalized)\"
            public let title = \"\(escape(displayTitle))\"
            public let url = URL(string: \"https://leetcode.cn/problems/\(details.slug)/\")!
            public let tags: [ProblemTag] = \(tagsLiteral)
            public let isEnabled = false

            public init() {}

            // TODO: 编写题解代码与本地调试入口
        }
        """
        .trimmingCharacters(in: .whitespacesAndNewlines)

        return (typeName, fileName, content)
    }

    private static func docComment(from markdown: String) -> String {
        markdown
            .components(separatedBy: .newlines)
            .map { line in
                if line.trimmingCharacters(in: .whitespaces).isEmpty {
                    return "///"
                }
                return "/// \(line)"
            }
            .joined(separator: "\n")
    }

    private static func normalizedID(_ id: String) -> String {
        if let value = Int(id) {
            return String(format: "%04d", value)
        }
        return id
    }

    private static func makeTypeSuffix(from slug: String) -> String {
        slug
            .split { !$0.isLetter && !$0.isNumber }
            .map { $0.capitalized }
            .joined()
    }

    private static func tagLiteral(from tags: [String]) -> String {
        guard tags.isEmpty == false else { return "[]" }
        let values = tags.map { literal(forTag: $0) }.joined(separator: ", ")
        return "[\(values)]"
    }

    private static func literal(forTag raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()
        switch lower {
        case "daily": return ".daily"
        case "weekly": return ".weekly"
        case "contest": return ".contest"
        default:
            break
        }

        let parts = trimmed.split(separator: ":", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            let prefix = parts[0].lowercased()
            let value = escape(parts[1])
            switch prefix {
            case "topic": return ".topic(\"\(value)\")"
            case "company": return ".company(\"\(value)\")"
            case "difficulty": return ".difficulty(\"\(value)\")"
            default: break
            }
        }
        return ".custom(\"\(escape(trimmed))\")"
    }

    private static func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
