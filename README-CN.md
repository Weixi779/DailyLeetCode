# DailyLeetCode 说明（中文）

## 工程拆分
- `DailyLeetCode/`：新的 Swift Package 工作区，内含 `DailyLeetCodeCore`、`DailyLeetCodeRunner` 以及即将扩展的 CLI/生成器。
- `Leetcode-Weixi/`：旧 Xcode 工程，继续承担历史题解、调试入口和临时脚本。

## 主要类型
- `LeetCodeTask`：统一协议，规定题目 ID、标题、URL、tags 和 `run()`。不再区分每日/专项基类，分类信息完全由你填写的 tags 表达。
- `TaskRegistry` & `TaskCatalog`：负责注册和列出任务。引导 `DailyLeetCodeRunner` 从同一入口执行题目。
- `DailyLeetCodeRunner`：命令行入口，默认跑全部任务，可通过题号或 `--tag 某标签` 快速筛选。
- `ProblemMetadataFetcher`：读取 `.leetcode.env`，创建 `LeetCodeClient`，供生成器用 URL 拉取题号、难度和中文描述。
- `LeetCodeAPI` 模块：独立 Package，封装 GraphQL payload、Cookie 解析和 `ProblemDetails` 模型。
- `HotProblem`/`HotProblem2025` 与 `ListNode`/`TreeNode`/`Node`：旧工程中的通用结构与 Hot100 解法，仍可复用。

## 题文件结构
- 所有新题统一放在 `DailyLeetCode/Sources/DailyLeetCodeCore/Problems/`。
- 文件命名建议 `LTXXXX_ProblemName.swift`（如 `LT0088_MergeSortedArray.swift`），以 LeetCode 题号排序。
- 文件内部实现 `LeetCodeTask`，填写 `tags`（如 `["daily", "two-pointers"]`），并在 `ProblemCatalog.all` 列表中追加。下文的生成器会自动完成这些步骤。

## Token 配置
1. 浏览器登录 LeetCode，从开发者工具复制整段 Cookie（包含 `csrftoken` 与 `LEETCODE_SESSION`）。
2. 在仓库根目录执行：
   ```bash
   bash scripts/extract_leetcode_cookie.sh '<完整的 cookie>'
   # 或
   pbpaste | bash scripts/extract_leetcode_cookie.sh
   ```
3. 脚本会写入 `DailyLeetCode/.leetcode.env`，内容已被 `.gitignore` 忽略。Cookie 过期时重复上述步骤。

## 元数据测试
准备好 `.leetcode.env` 后，可直接调用 Runner 拉取题目信息：

```bash
cd DailyLeetCode
swift run DailyLeetCodeRunner --fetch-url=https://leetcode.cn/problems/two-sum/
```

命令会输出题号、中文标题、难度、链接与中文描述（若无翻译则回退英文），方便复制到 Swift 文档注释。

## Xcode 中按 `⌘R`
- 打开 `DailyLeetCode.xcworkspace`，选择 `DailyLeetCodeRunner`（或自建一个引用 `DailyLeetCodeCore` 的 Command Line Tool）。
- 每个题的 `run()` 默认是空实现，按需覆写并加入样例调用。
- 在 Xcode 里按 `⌘R` 即可运行当前 Runner，直接在控制台查看输出，便于交互式调试。

## 自动生成题文件

```bash
cd DailyLeetCode
swift run ProblemScaffolder --url=https://leetcode.cn/problems/merge-sorted-array/ --tags=daily,array
```

命令会读取 `.leetcode.env`，抓取中文题面，生成 `LTXXXX_Title.swift` 文件（含 Doc 注释和占位代码），并自动在 `ProblemCatalog` 中注册。若目标文件已存在可加 `--force` 覆盖，若凭证文件不在默认位置可用 `--env=<path>` 指定。
