# Agent Skills

A collection of reusable agent skills for common development workflows. Each skill includes its own instructions and documentation.

## Available skills

| Skill | Purpose | Documentation |
| --- | --- | --- |
| Plan Handoff | Save finalized plans as Markdown and track implementation milestones, blockers, and verification through completion. | [SKILL.md](skills/plan-handoff/SKILL.md) |
| Session Handover | Check account usage and save continuation notes at 5% or less remaining in the five-hour or weekly allowance, or on request. | [SKILL.md](skills/session-handover/SKILL.md) |

## Installation

These instructions install the skills for your user account in Codex's `~/.agents/skills` directory. You need Git and either Bash (macOS, Linux, or WSL) or PowerShell (Windows). Session Handover's local usage-log fallback also requires Python 3.

### macOS, Linux, and WSL

Clone the repository and enter it:

```sh
git clone https://github.com/davidchan3320/skills.git
cd skills
```

Install both skills from the repository root:

```sh
./install.sh
```

Install one skill, list available skills, or choose a different destination:

```sh
./install.sh session-handover
./install.sh --list
./install.sh --dest ./my-project/.agents/skills plan-handoff
```

The installer copies each complete skill directory, including its scripts and metadata. It works from any working directory when called by its path. Relative destinations are resolved from your current working directory. Run `./install.sh --help` for options.

### Windows PowerShell

Clone the repository and run the PowerShell installer from its root:

```powershell
git clone https://github.com/davidchan3320/skills.git
cd skills
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Install one skill, list available skills, or choose a different destination:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 session-handover
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -List
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Dest .\my-project\.agents\skills plan-handoff
```

The PowerShell installer has the same copy and update behavior as `install.sh`. `-Dest` is resolved from the current directory; its default is `$HOME\.agents\skills`. The execution policy setting applies only to the installer process. Run it with `-Help` for options.

Start a new Codex session after installation. If the skills do not appear, restart Codex. In Codex CLI or the IDE extension, use `/skills` or type `$` to find them. See the [official skill documentation](https://learn.chatgpt.com/docs/build-skills) for discovery and installation locations.

## Usage

Invoke a skill by name:

> Use plan-handoff to save this finalized plan.

> Use session-handover to document the current work and next steps.

Session Handover also instructs the agent to check account usage during sustained work and save a handover when the five-hour or weekly allowance has **5% or less remaining**. Automatic invocation is best effort; the skill is not a background monitor.

To check the usage-log fallback from a terminal belonging to an active Codex session on macOS, Linux, or WSL:

```sh
python3 "$HOME/.agents/skills/session-handover/scripts/check_usage.py"
```

The helper uses `CODEX_HOME` (defaulting to `~/.codex`) and `CODEX_THREAD_ID` or `CODEX_SESSION_ID` to locate the current session. It returns `unknown` when the session or a fresh usage reading is unavailable. An ordinary terminal may lack these environment variables. The helper only reports usage; the agent writes the handover.

On Windows, use `py -3 "$HOME\.agents\skills\session-handover\scripts\check_usage.py"` from a PowerShell terminal belonging to the active session.

See each skill's documentation in the table above for its full workflow.

## Updating

Installed skills are copies, so pulling this repository does not update them automatically. From your local clone, pull the latest version and rerun the installer:

```sh
git pull --ff-only
./install.sh
```

Pass skill names to update only those skills, and repeat `--dest` if you used a custom location. Matching installed files are overwritten and extra destination files are preserved; preserve any local customizations first. Start a new Codex session to use the updated instructions.

On Windows PowerShell, run `git pull --ff-only` and then rerun `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1`, adding skill names or `-Dest` as needed.

## License

Licensed under the [MIT License](LICENSE).
