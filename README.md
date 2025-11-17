# DailyLeetCode Workspace

_中文版请见 [README-CN.md](README-CN.md)_

## Structure
- `DailyLeetCode/`: Swift Package workspace with `DailyLeetCodeCore`, `DailyLeetCodeRunner`, and future generators.
- `Leetcode-Weixi/`: legacy Xcode project retaining historical solutions and scratch space.

## Core Types
- `LeetCodeTask`, `DailyTask`, `TopicTask` (in `DailyLeetCodeCore`): shared protocols exposing metadata (`id`, `title`, `url`, `category`) plus a `run()` entrypoint so both daily drills and topic drills behave uniformly.
- `TaskRegistry` & `TaskCatalog`: register every task and let the runner list/execute them without manual wiring.
- `DailyLeetCodeRunner`: CLI entry (`swift run DailyLeetCodeRunner`) that runs every registered task or filters by `--category` / ID.
- `ProblemMetadataFetcher` + `LeetCodeAPI`: load cookies from `.leetcode.env`, call the LeetCode GraphQL endpoint, and return `ProblemDetails` (id, slug, content, sample testcases) to feed your template generator.
- `HotProblem`, `HotProblem2025`, plus helpers (`ListNode`, `TreeNode`, `Node`) inside `Leetcode-Weixi/Leetcode-Weixi`: legacy implementations for common data structures and curated Hot100 problems.

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

The runner prints the problem ID, slug, translated title (if available), and bundled sample testcases so generators can reuse them.
