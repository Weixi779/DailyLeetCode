import DailyLeetCodeCore
import Foundation

@MainActor
@main
struct DailyLeetCodeRunner {
    static func main() async {
        let code = await runAndExitCode()
        Foundation.exit(code.rawValue)
    }

    private static func runAndExitCode() async -> RunnerExitCode {
        TaskCatalog.bootstrap().forEach { TaskRegistry.shared.register($0) }

        do {
            let command = try RunnerCLIParser.parse(arguments: Array(CommandLine.arguments.dropFirst()))
            return await RunnerCommandExecutor.execute(command)
        } catch let help as RunnerHelpRequestedError {
            print(help.message)
            return .success
        } catch let error as RunnerCLIError {
            fputs("参数错误：\(error.message)\n", stderr)
            fputs("使用帮助：swift run DailyLeetCodeRunner help\n", stderr)
            return .usage
        } catch {
            fputs("运行失败：\(error)\n", stderr)
            return .failure
        }
    }
}
