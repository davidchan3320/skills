# Agent Skills

A collection of reusable agent skills for common development workflows. Each skill includes its own instructions and documentation.

## Available skills

| Skill | Purpose | Documentation |
| --- | --- | --- |
| Plan Handoff | Save finalized plans as Markdown and track implementation milestones, blockers, and verification through completion. | [SKILL.md](skills/plan-handoff/SKILL.md) |

## Quick start

From this repository’s root, install an individual skill into your personal skills directory. For example, to install Plan Handoff:

```sh
mkdir -p ~/.agents/skills/
cp -R skills/plan-handoff ~/.agents/skills/
```

Invoke the installed skill with a prompt such as:

> Use plan-handoff to save this finalized plan.

See the [Plan Handoff documentation](skills/plan-handoff/SKILL.md) for its full workflow and handoff format.

## License

Licensed under the [MIT License](LICENSE).
