# DailyLeetCode Workspace

_中文版请见 [README-CN.md](README-CN.md)_

## Structure
- `DailyLeetCode/`: Swift Package workspace with `DailyLeetCodeCore`, `DailyLeetCodeRunner`, and future generators.
- `Leetcode-Weixi/`: legacy Xcode project retaining historical solutions and scratch space.

## Core Types
- `LeetCodeTask` (in `DailyLeetCodeCore`): exposes `id`, `title`, `url`, an array of free-form tags, plus `run()`. No more daily/topic inheritance; classification lives entirely in the tags you assign.
- `TaskRegistry` & `TaskCatalog`: register every task and let the runner list/execute them without manual wiring.
- `DailyLeetCodeRunner`: CLI entry (`swift run DailyLeetCodeRunner`) that runs every registered task, filters by ID, or filters by `--tag some-tag`.
- `ProblemMetadataFetcher` + `LeetCodeAPI`: load cookies from `.leetcode.env`, call the LeetCode GraphQL endpoint, and return `ProblemDetails` (id, slug, difficulty, Chinese markdown description) to feed your template generator.
- `HotProblem`, `HotProblem2025`, plus helpers (`ListNode`, `TreeNode`, `Node`) inside `Leetcode-Weixi/Leetcode-Weixi`: legacy implementations for common data structures and curated Hot100 problems.

## Problem Files
- New problems live under `DailyLeetCode/Sources/DailyLeetCodeCore/Problems/`.
- Name files `LTXXXX_Title.swift` (e.g., `LT0088_MergeSortedArray.swift`) so they sort naturally by LeetCode ID.
- Conform to `LeetCodeTask`, provide whatever tags you need (e.g., `[.daily, .topic("dp"), .custom("array")]` or string-literals such as `["daily", "topic:greedy"]`), and keep `ProblemCatalog.all` updated. The generator described below automates both steps.

## Cookie/Token Setup
1. Log into LeetCode in the browser and copy the full cookie string (must contain `csrftoken` and `LEETCODE_SESSION`).
2. Run either command from the repo root:
   ```bash
   bash scripts/extract_leetcode_cookie.sh 'gr_user_id=...; csrftoken=...; LEETCODE_SESSION=...'
   # or
   pbpaste | bash scripts/extract_leetcode_cookie.sh
   ```
3. The script writes `DailyLeetCode/.leetcode.env` with `LEETCODE_SESSION`, `LEETCODE_CSRF`, `LEETCODE_ENDPOINT`. The file is gitignored; re-run the script whenever the cookie expires.

## Metadata Fetch Command
After `.leetcode.env` is populated, you can probe any problem metadata directly:

```bash
cd DailyLeetCode
swift run DailyLeetCodeRunner --fetch-url=https://leetcode.cn/problems/two-sum/
```

The runner prints the problem ID, localized difficulty, link, and Chinese description so you can paste it directly into Swift doc comments.

Shortcuts (repo root):
- `scripts/dl.sh runner [args]` → `swift run DailyLeetCodeRunner ...`
- `scripts/dl.sh scaffold [args]` → `swift run ProblemScaffolder ...`
- Omit subcommand to default to runner passthrough.

## Running in Xcode (`⌘R`)
- Open `DailyLeetCode.xcworkspace`, pick the `DailyLeetCodeRunner` scheme (or create a scratch Command Line Tool that imports `DailyLeetCodeCore`).
- Implement `run()` inside each problem struct however you like (the protocol provides an empty default), e.g. calling the solution with sample inputs.
- Hit `⌘R` to execute the active runner and inspect console output without leaving Xcode.

## Problem Generator
Automate scaffold creation with:

```bash
cd DailyLeetCode
swift run ProblemScaffolder --url=https://leetcode.cn/problems/merge-sorted-array/ --tags=daily,array
```

This fetches Chinese metadata, writes `LTXXXX_Title.swift` with doc comments + boilerplate, and appends the new type to `ProblemCatalog`. Tags understand prefixes such as `topic:dp`, `company:bytedance`, `difficulty:hard`; unknown tags fall back to `.custom("...")`. Use `--force` to overwrite an existing file or `--env=/custom/.leetcode.env` to point at a different credential file.

## Optional Next Steps
- Clean tracked build artifacts with `git rm -r --cached LeetCodeAPI/.build DailyLeetCode/.build` so the `.gitignore` rules take effect.
- When files grow large, extend the generator to bucket directories by ID range (e.g., `LT0001-LT0100`) to keep Finder/Xcode tidy.
- Add a test stub or sample assertion section in the generator template if you want ready-made places to paste LeetCode samples.
- Create an extra lightweight Runner scheme in Xcode that only registers the current WIP problem, so `⌘R` runs a single task.
