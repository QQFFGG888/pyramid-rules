# pyramid-tutorial

金字塔式教程生成。一个面向 AI Agent 的 Skill，以一个主题名为最小输入，生成四层递进、面向零基础读者的完整教程。

## 1 方法论

四层金字塔，逐层向上，绝不跳层。

- L1 纯生活比喻，建立直觉。
- L2 比喻与术语对照，知晓名词。
- L3 精简技术语言，准确理解。
- L4 实操配置，便于上手。

叠加十条规则边界：双端自包含、纯交付物、自然引导、章末检验、一句一事实、富文本辅助、符号从简、数字编号三级标题、文首元信息、去 AI 感润色。结构上另有单元四带与名词锚。

## 2 目录结构

```
pyramid-tutorial/
├── SKILL.md                    # 技能主文件：触发条件、单元四带、生成流程、输出格式
├── references/
│   ├── pyramid-rules.md        # 四层填充规则、单元四带、名词锚、铁律、正反例
│   ├── blocks.md               # 可复用区块模板：元信息、原文带、名词锚、自检等
│   └── selfcheck.md            # 自检配方与人工项判读标准
├── examples/
│   └── rag-tutorial.md         # 单概念完整教程示例
├── scripts/
│   └── selfcheck.sh            # 机械计数项自检脚本
├── README.md                   # 仓库说明：安装、用法、目录与版本
└── LICENSE                     # MIT
```

## 3 安装

将本目录复制到你的 Agent skills 目录。

WorkBuddy 用户级目录为 `~/.workbuddy/skills/pyramid-tutorial/`。

从 GitHub 安装：

```
git clone https://github.com/QQFFGG888/pyramid-rules.git pyramid-tutorial
```

## 4 快速开始

在对话中给出主题即可触发，或显式说明使用本技能。

```
用金字塔式教程生成一篇 RAG 教程
```

## 5 生成流程

1. 输入解析：缺失项按默认值补齐，文首写「本篇约定」。
2. 金字塔规划：选比喻系统、列概念清单、填四层内容单、定章节骨架。
3. 逐层撰写：按 L1 到 L4 顺序写每个概念，章末附自检。
4. 结构与排版：单元四带（原文带、深读带、通读带、收束带）、术语编号锚、数字编号三级标题、符号从简、文首元信息。
5. 自检与交付：跑 selfcheck.sh，过人工项，不带病交付。

细节见 SKILL.md 与 references/。

## 6 自检

生成完成后运行：

```
bash scripts/selfcheck.sh 产出文件.md
```

脚本覆盖 AI 套话、感叹号、省略号、修订说明词、元叙述、五级标题等机械计数项。小白复读、比喻一致、因果链闭合等人工项按 `references/selfcheck.md` 判读。

## 7 许可

MIT License，见 LICENSE。

## 8 版本

v5。结构升级：单元四带落地，术语编号锚、章末名词与文末四列速查表。
