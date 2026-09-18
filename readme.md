# Agent Skills

A collection of reusable agent skills for common development workflows. Each skill includes its own instructions and documentation.

## Available skills

| Skill | Purpose | Documentation |
| --- | --- | --- |
| Plan Handoff | Save finalized plans as Markdown and track implementation milestones, blockers, and verification through completion. | [SKILL.md](skills/plan-handoff/SKILL.md) |
| Session Handover | Check account usage and save continuation notes at 5% or less remaining in the five-hour or weekly allowance, or on request. | [SKILL.md](skills/session-handover/SKILL.md) |

## Installation

These instructions install the skills for your user account in Codex's `~/.agents/skills` directory. You need Git to clone the repository. Session Handover's local usage-log fallback also requires Python 3.

Clone the repository and enter it:

```sh
git clone https://github.com/davidchan3320/skills.git
cd skills
```

Install both skills from the repository root:

```sh
for skill in plan-handoff session-handover; do
  mkdir -p "$HOME/.agents/skills/$skill"
  cp -R "skills/$skill/." "$HOME/.agents/skills/$skill/"
done
```

To install only one skill, keep only its name in the `for skill in ...` line. Copy the entire skill directory: Session Handover needs its `scripts/` directory as well as `SKILL.md`.

Start a new Codex session after installation. If the skills do not appear, restart Codex. In Codex CLI or the IDE extension, use `/skills` or type `$` to find them. See the [official skill documentation](https://learn.chatgpt.com/docs/build-skills) for discovery and installation locations.

## Usage

Invoke a skill by name:

> Use plan-handoff to save this finalized plan.

> Use session-handover to document the current work and next steps.

Session Handover also instructs the agent to check account usage during sustained work and save a handover when the five-hour or weekly allowance has **5% or less remaining**. Automatic invocation is best effort; the skill is not a background monitor.

To check the usage-log fallback from a terminal belonging to an active Codex session:

```sh
python3 "$HOME/.agents/skills/session-handover/scripts/check_usage.py"
```

The helper uses `CODEX_HOME` (defaulting to `~/.codex`) and `CODEX_THREAD_ID` or `CODEX_SESSION_ID` to locate the current session. It returns `unknown` when the session or a fresh usage reading is unavailable. An ordinary terminal may lack these environment variables. The helper only reports usage; the agent writes the handover.

See each skill's documentation in the table above for its full workflow.

## Updating

Installed skills are copies, so pulling this repository does not update them automatically. From your local clone, pull the latest version and copy the skills again:

```sh
git pull --ff-only
for skill in plan-handoff session-handover; do
  mkdir -p "$HOME/.agents/skills/$skill"
  cp -R "skills/$skill/." "$HOME/.agents/skills/$skill/"
done
```

Keep only the skills you want to update in the loop. This overwrites matching installed files; preserve any local customizations first. Start a new Codex session to use the updated instructions.

## License

Licensed under the [MIT License](LICENSE).
