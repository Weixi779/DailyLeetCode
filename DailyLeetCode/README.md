# DailyLeetCode

Swift Package 工作区，核心代码在 `Sources/DailyLeetCodeCore`，命令行入口为 `DailyLeetCodeRunner`，生成器为 `ProblemScaffolder`。

## 运行
```bash
swift run DailyLeetCodeRunner run                # 默认只运行 isEnabled=true 的题
swift run DailyLeetCodeRunner run --id LT0088    # 按题号运行（可临时验证）
swift run DailyLeetCodeRunner run --tag=daily    # 按标签运行（默认仍过滤 enabled）
swift run DailyLeetCodeRunner list --all         # 查看全部题
swift run DailyLeetCodeRunner help               # 查看帮助
```
快捷方式：在仓库根目录使用 `scripts/dl.sh ...`，无需输入完整 `swift run`。

## 题目文件
- 存放于 `Sources/DailyLeetCodeCore/Problems/`，命名 `LTXXXX_Title.swift`。
- 实现 `LeetCodeTask` 并填写 `tags`（支持 `.daily`, `.topic("dp")`, `.custom("array")` 等），`run()` 有默认空实现，按需覆写。
- 新增题目后将类型加入 `ProblemCatalog.all`（生成器会自动更新）。

## 生成器
```bash
swift run ProblemScaffolder scaffold --url=https://leetcode.cn/problems/merge-sorted-array/ --tags=daily,array
```
自动抓取中文题面/难度，生成文件并注册到 `ProblemCatalog`。新题默认 `isEnabled=false`。支持 `--force` 覆盖，`--env=<path>` 指定凭证。

## Cookie/Token 配置
1. 浏览器登录后复制整段 Cookie（含 `csrftoken`、`LEETCODE_SESSION`）。
2. 在仓库根执行：
   ```bash
   bash scripts/extract_leetcode_cookie.sh 'gr_user_id=...; csrftoken=...; LEETCODE_SESSION=...'
   # 或
   pbpaste | bash scripts/extract_leetcode_cookie.sh
   ```
3. 脚本写入 `DailyLeetCode/.leetcode.env`（已 gitignore）；过期时重复。

## Xcode (`⌘R`)
打开 `DailyLeetCode.xcworkspace`，选 `DailyLeetCodeRunner` Scheme 或自建入口，按 `⌘R` 运行；`run()` 默认空实现，覆写后即可用作本地调试入口。
