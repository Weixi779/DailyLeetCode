import Foundation

public struct GeneratorArguments {
    public var url: URL?
    public var tags: [String]
    public var force: Bool
    public var envPath: String

    public init(url: URL? = nil, tags: [String] = [], force: Bool = false, envPath: String = ".leetcode.env") {
        self.url = url
        self.tags = tags
        self.force = force
        self.envPath = envPath
    }
}

public enum GeneratorError: Error, CustomStringConvertible {
    case missingURL
    case fileAlreadyExists(String)
    case catalogFormatInvalid
    case unknownArgument(String)
    case helpRequested

    public var description: String {
        switch self {
        case .missingURL:
            return "Missing --url argument"
        case .fileAlreadyExists(let path):
            return "File already exists at \(path). Pass --force to overwrite."
        case .catalogFormatInvalid:
            return "ProblemCatalog.swift structure not recognized"
        case .unknownArgument(let value):
            return "Unknown argument: \(value)"
        case .helpRequested:
            return "help requested"
        }
    }
}

public enum ScaffolderExitCode: Int32 {
    case success = 0
    case failure = 1
    case usage = 64
}
