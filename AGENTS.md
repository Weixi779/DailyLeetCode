# Repository Guidelines

## Project Structure & Module Organization
The repository root holds the Xcode project at `Leetcode-Weixi/Leetcode-Weixi.xcodeproj` and all Swift sources under `Leetcode-Weixi/Leetcode-Weixi`. Year folders such as `2024/5/240525.swift` encapsulate date-stamped solution classes (e.g., `LeetCode2024.May.Solution240525`). Shared data structures live beside them (`ListNode.swift`, `TreeNode.swift`, `Node.swift`) and should be reused rather than redefined. Keep orchestration or quick experiments inside `main.swift`, while `Hot100/HotProblem.swift` aggregates evergreen solutions referenced by `HotProblem2025`.

## Build, Test, and Development Commands
- `open Leetcode-Weixi/Leetcode-Weixi.xcodeproj` – launch the app in Xcode for interactive editing and running (`⌘R` executes `main.swift`).
- `xcodebuild -project Leetcode-Weixi/Leetcode-Weixi.xcodeproj -scheme Leetcode-Weixi -destination 'platform=macOS' build` – headless CI build to ensure every Swift file compiles.
- `xcodebuild -project Leetcode-Weixi/Leetcode-Weixi.xcodeproj -scheme Leetcode-Weixi -destination 'platform=macOS' test` – runs the (currently empty) test bundle and guards against future regressions; wire new XCTest targets into the same scheme.

## Coding Style & Naming Conventions
Use Swift 5 defaults with 4-space indentation and `camelCase` identifiers. Name solution types `SolutionYYMMDD` inside the matching `LeetCode<Year>.<Month>` extension to keep historical ordering obvious. Prefer pure functions with clear parameter labels, leverage `MARK:` comments for major sections as shown in `HotProblem.swift`, and favor extensions over new global types for grouping related problems.

## Testing Guidelines
When adding a solution, include at least one deterministic scenario driven either from `main.swift` or an XCTest such as `Solution240525Tests.testFindIndices()`. Keep test methods descriptive (`test<Problem><Scenario>`), assert exact outputs, and cover both edge cases and expected paths. Run `xcodebuild -project Leetcode-Weixi/Leetcode-Weixi.xcodeproj -scheme Leetcode-Weixi -destination 'platform=macOS' test` locally before pushing; if exploratory inputs are needed, document the sample invocation placed in `main.swift` so others can reproduce it.

## Commit & Pull Request Guidelines
Match the existing conventional-commit style (`feat: update 0416`, `fix: ...`). Prefix messages with the scope (`feat`, `fix`, `docs`, `chore`) and keep the summary under 60 characters. Pull requests should explain the solved problems, mention added files (e.g., `2024/7/240701.swift`), link to the LeetCode prompt, and include screenshots or console output that demonstrates the solution passing its sample cases.
