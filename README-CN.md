# DailyLeetCode 说明（中文）

## 工程拆分
- `DailyLeetCode/`：新的 Swift Package 工作区，内含 `DailyLeetCodeCore`、`DailyLeetCodeRunner` 以及即将扩展的 CLI/生成器。
- `Leetcode-Weixi/`：旧 Xcode 工程，继续承担历史题解、调试入口和临时脚本。

## 主要类型
- `LeetCodeTask` / `DailyTask` / `TopicTask`：统一协议，规定题目 ID、标题、URL、分类和 `run()`。Daily/Topic 仅在此基础上补充元数据，保持调用一致性。
- `TaskRegistry` & `TaskCatalog`：负责注册和列出任务。引导 `DailyLeetCodeRunner` 从同一入口执行每日题或专项题。
- `DailyLeetCodeRunner`：命令行入口，默认跑全部任务，支持 `--category` 或题号过滤。
- `ProblemMetadataFetcher`：读取 `.leetcode.env`，创建 `LeetCodeClient`，供生成器用 URL 拉取题号、描述、测试样例。
- `LeetCodeAPI` 模块：独立 Package，封装 GraphQL payload、Cookie 解析和 `ProblemDetails` 模型。
- `HotProblem`/`HotProblem2025` 与 `ListNode`/`TreeNode`/`Node`：旧工程中的通用结构与 Hot100 解法，仍可复用。

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

命令会输出题目 ID、英文/中文标题及示例测试用例，后续生成器可以复用这些内容。
