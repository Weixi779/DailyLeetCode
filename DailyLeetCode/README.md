# DailyLeetCode

新架构由 Swift Package 管理，核心代码位于 `Sources/DailyLeetCodeCore`，并按 `Daily` / `Topic` 分类。命令行入口 `DailyLeetCodeRunner` 依赖核心模块，负责选择任务并执行样例。

## 运行

在包目录执行：

```bash
swift run DailyLeetCodeRunner          # 运行全部注册任务
swift run DailyLeetCodeRunner 000000   # 按题目 id 执行
swift run DailyLeetCodeRunner --category=daily  # 仅跑每日任务
```

## 扩展
- 新增每日/专项题目时，在对应文件夹内添加 `DailyTask` 或 `TopicTask` 实现，并将实例挂到 `TaskCatalog.bootstrap()`。
- 之后可以由 CLI 生成器负责自动写入文件与注册逻辑。
- 访问 LeetCode GraphQL 时，可手工 `cp .leetcode.env.example .leetcode.env` 并填写 `LEETCODE_SESSION` 与 `csrftoken`，或运行 `scripts/extract_leetcode_cookie.sh` 粘贴整段 Cookie 自动生成；后续工具即可安全读取。
- 网络能力由专门的 `LeetCodeAPI` 包提供，`ProblemMetadataFetcher` 会读取 `.leetcode.env` 并创建 `LeetCodeClient`，未来生成器脚本可直接利用该客户端获取题目编号/描述/样例。

打开 `DailyLeetCode.xcworkspace` 即可在 Xcode 内获得完整的自动补全与文档能力。

## Cookie/Token 配置

1. 先在浏览器完成登录并复制整段 Cookie（含 `csrftoken`、`LEETCODE_SESSION`）。
2. 在仓库根目录执行以下任一方式：
   ```bash
   bash scripts/extract_leetcode_cookie.sh 'gr_user_id=...; csrftoken=...; LEETCODE_SESSION=...'
   # 或
   pbpaste | bash scripts/extract_leetcode_cookie.sh
   ```
3. 脚本会在 `DailyLeetCode/.leetcode.env` 写入 `LEETCODE_SESSION`、`LEETCODE_CSRF`、`LEETCODE_ENDPOINT`。该文件已被 `.gitignore` 忽略，如果 Cookie 过期，重复上述步骤即可。
