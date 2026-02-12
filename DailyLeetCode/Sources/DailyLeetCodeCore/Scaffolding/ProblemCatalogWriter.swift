import Foundation

public enum ProblemCatalogWriter {
    public static func appendIfNeeded(typeName: String, basePath: String) throws {
        let catalogURL = URL(fileURLWithPath: basePath)
            .appendingPathComponent("Sources/DailyLeetCodeCore/Problems/ProblemCatalog.swift")
        var content = try String(contentsOf: catalogURL)

        if content.contains("\(typeName)()") {
            return
        }

        guard let insertionRange = content.range(of: "\n    ]", options: .backwards) else {
            throw GeneratorError.catalogFormatInvalid
        }

        let insertion = "        \(typeName)(),\n"
        let prefix = content[..<insertionRange.lowerBound]
        let suffix = content[insertionRange.lowerBound...]
        content = String(prefix) + insertion + String(suffix)

        try content.write(to: catalogURL, atomically: true, encoding: .utf8)
    }
}
