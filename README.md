# Agent Marketplace

A curated collection of skills and plugins for AI agents. Extend your agent capabilities with specialized workflows and integrations.

## Quick Start

### Installation

#### Method 1

[Click to Install to VS Code](vscode://chat-plugin/add-marketplace?ref=MrMYHuang/agent-marketplace)

#### Method 2

1. Clone or download this repository into your agent plugins directory.
2. Navigate to the `myh-plugin` folder — skills are organized here.
3. Each skill is self-contained with a `SKILL.md` file describing how to use it.

### Using a Skill

Skills integrate directly into your agent. Reference a skill by name in your workflow:

- Load the skill file (e.g., `myh-plugin/skills/github-fix-this/SKILL.md`)
- Follow the **Prerequisites** and **Workflow** sections
- The skill will guide you through each step

**Example:** The `github-fix-this` skill automates GitHub workflow — from issue to pull request in one go.

## Available Skills

| Skill | Purpose | Prerequisites |
|-------|---------|---|
| **github-fix-this** | Automate GitHub issue-to-PR workflow | `gh` CLI authenticated, Git repo with remote |
| **sqlcl** | Query/modify Oracle databases via SQLcl | SQLcl installed, saved named connection |

## Folder Structure

```
agent-marketplace/
├── myh-plugin/
│   └── skills/
│       ├── github-fix-this/      # GitHub workflow automation
│       │   └── SKILL.md
│       └── sqlcl/                # Oracle database tool
│           ├── SKILL.md
│           ├── agents/           # Agent configs (e.g., openai.yaml)
│           └── references/       # Usage examples & docs
├── myh-hooks/
│   └── hooks.json                # Agent lifecycle hooks
└── README.md                      # This file
```

## Resources

- **Skill Documentation** — Each skill has a `SKILL.md` with detailed workflow and examples
- **Agent Configuration** — See `myh-plugin/skills/*/agents/` for agent-specific setup
- **References** — Additional guides and examples in `myh-plugin/skills/*/references/`

## Contributing

To add a new skill:

1. Create a folder under `myh-plugin/skills/<skill-name>/`
2. Write a `SKILL.md` with **Prerequisites**, **Workflow**, and **Checklist**
3. Include supporting files (agents, references) as needed
4. Update this README with the new skill entry

---

**Questions?** Refer to individual skill documentation for detailed usage patterns and troubleshooting.
