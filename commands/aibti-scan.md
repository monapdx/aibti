---
description: 扫描 Claude Code 对话历史，生成 AIBTI 人格报告（默认 7 天）
argument-hint: "[days=7]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
---

# /aibti-scan

使用 AIBTI Skill 分析最近 $ARGUMENTS 天（默认 7 天）的提示词历史，生成带理论依据的人格报告。

## 执行步骤

1. 加载 `aibti` Skill（见 `skills/aibti/SKILL.md`）
2. 扫描 `~/.aibti/prompts.jsonl`（如果存在）或 `~/.claude/projects/**/*.jsonl`
3. 按 Skill 的语义判定逻辑对每条 prompt 打 4 字母标签
4. 聚合出主人格 + 四维占比 + 意图分布
5. 引用 3-5 条用户真实说过的 prompt 作为佐证
6. 按 Skill 模板输出报告，每条诊断挂大神理论（Anthropic / OpenAI / Karpathy / CoT / ReAct）

## 重要约束

- **用语义判定，不要用正则**：讨论/创造/战略类 prompt 不能误判成"指令型"
- 接续词（继续/修改/确认）不计入主人格
- 引用的真实 prompt 必须来自日志，禁止编造
- 敏感信息（邮箱/密钥/生产密码）自动脱敏为 `<REDACTED>`
