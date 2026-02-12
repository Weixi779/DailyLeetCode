import DailyLeetCodeCore
import Foundation

@main
struct ProblemScaffolder {
    static func main() async {
        let code = await runAndExitCode()
        exit(code.rawValue)
    }

    private static func runAndExitCode() async -> ScaffolderExitCode {
        do {
            let arguments = try ScaffolderCLIParser.parse(arguments: Array(CommandLine.arguments.dropFirst()))
            try await ProblemScaffoldGenerator.generate(arguments: arguments)
            return .success
        } catch GeneratorError.helpRequested {
            print(ScaffolderCLIParser.usage)
            return .success
        } catch let error as GeneratorError {
            fputs("参数错误: \(error)\n", stderr)
            print(ScaffolderCLIParser.usage)
            return .usage
        } catch {
            fputs("运行失败: \(error)\n", stderr)
            return .failure
        }
    }
}
