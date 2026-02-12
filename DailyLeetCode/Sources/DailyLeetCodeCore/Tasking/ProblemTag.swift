import Foundation

public enum ProblemTag: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    case daily
    case weekly
    case contest
    case topic(String)
    case company(String)
    case difficulty(String)
    case custom(String)

    public init(stringLiteral value: StringLiteralType) {
        self = ProblemTag.parse(value)
    }

    public init(_ value: String) {
        self = ProblemTag.parse(value)
    }

    public var description: String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .contest: return "contest"
        case .topic(let value): return "topic:\(value)"
        case .company(let value): return "company:\(value)"
        case .difficulty(let value): return "difficulty:\(value)"
        case .custom(let value): return value
        }
    }

    public var rawDescription: String { description }

    private static func parse(_ raw: String) -> ProblemTag {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()
        switch lower {
        case "daily": return .daily
        case "weekly": return .weekly
        case "contest": return .contest
        default:
            break
        }
        let parts = trimmed.split(separator: ":", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            let prefix = parts[0].lowercased()
            let value = parts[1]
            switch prefix {
            case "topic": return .topic(value)
            case "company": return .company(value)
            case "difficulty": return .difficulty(value)
            default: return .custom(trimmed)
            }
        }
        return .custom(trimmed)
    }
}
