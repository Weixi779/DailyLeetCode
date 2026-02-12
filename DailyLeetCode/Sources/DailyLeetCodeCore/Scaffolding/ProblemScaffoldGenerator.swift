import Foundation

public enum ProblemScaffoldGenerator {
    public static func generate(arguments: GeneratorArguments, basePath: String = FileManager.default.currentDirectoryPath) async throws {
        guard let problemURL = arguments.url else {
            throw GeneratorError.missingURL
        }

        let client = try ProblemMetadataFetcher.makeClient(envFileRelativePath: arguments.envPath)
        let details = try await client.fetchProblem(from: problemURL)

        let rendered = await ProblemTemplateRenderer.render(details: details, tags: arguments.tags)

        let problemsDir = URL(fileURLWithPath: basePath)
            .appendingPathComponent("Sources/DailyLeetCodeCore/Problems", isDirectory: true)
        try FileManager.default.createDirectory(at: problemsDir, withIntermediateDirectories: true)

        let fileURL = problemsDir.appendingPathComponent(rendered.fileName)
        if FileManager.default.fileExists(atPath: fileURL.path), arguments.force == false {
            throw GeneratorError.fileAlreadyExists(fileURL.path)
        }

        try rendered.content.write(to: fileURL, atomically: true, encoding: .utf8)
        try ProblemCatalogWriter.appendIfNeeded(typeName: rendered.typeName, basePath: basePath)

        print("Generated \(rendered.fileName)")
    }
}
