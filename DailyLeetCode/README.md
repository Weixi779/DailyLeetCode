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
- 访问 LeetCode GraphQL 时，将 `.leetcode.env.example` 复制为 `.leetcode.env`，把浏览器里复制的 `LEETCODE_SESSION` 与 `csrftoken` 填进去（内容已被 .gitignore 忽略），后续工具即可安全读取。

打开 `DailyLeetCode.xcworkspace` 即可在 Xcode 内获得完整的自动补全与文档能力。
