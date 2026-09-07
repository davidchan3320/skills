# Update the README for a skills collection

- **Status:** Completed
- **Created:** 2026-09-07 13:05+08:00
- **Last updated:** 2026-09-07 13:05+08:00
- **Supersedes:** None
- **Current blocker:** None
- **Next action:** None — implementation and required verification complete

## Goal
Present this repository as a general collection of reusable agent skills, with Plan Handoff as the first available skill.

## Implementation Changes
- Use “Agent Skills” as the top-level title and briefly explain the repository’s purpose.
- Add an “Available skills” table listing Plan Handoff, its purpose, and a link to its SKILL.md.
- Keep a “Quick start” section showing how to install an individual skill from the repository root, using Plan Handoff as the example.
- Include one example prompt for invoking the installed skill.
- Replace the detailed Plan Handoff workflow and status table with a link to that skill’s documentation.
- Retain the MIT license section.

## Interfaces and Types
None. No changes to skill behavior or public interfaces.

## Tests
- Confirm installation commands match the repository layout.
- Check Markdown formatting and relative links.
- Ensure the introduction describes the collection and clearly labels Plan Handoff as an individual skill.

## Assumptions
- Document only skills currently present; do not add speculative categories or contribution requirements.
- Save this plan to plans/2026-09-07-1303-update-skills-readme.md before implementation, using a numeric suffix if occupied, and track implementation and verification here.

## Milestones
- [x] Save the finalized plan.
- [x] Update the README.
- [x] Verify installation commands, Markdown, relative links, and collection framing.

## Progress Log
- 2026-09-07 13:05+08:00 — Finalized plan saved; implementation started with status `In progress`.

- 2026-09-07 13:05+08:00 — README updated with collection introduction, skill table, installation example, one invocation prompt, documentation links, and MIT license.

- 2026-09-07 13:05+08:00 — All required verification passed; implementation completed with no unresolved issues.

## Verification Results
- Passed: executed the README shell commands from the repository root with the destination redirected to a temporary directory; confirmed the installed SKILL.md matches the source byte for byte.
- Passed: Python assertions confirmed all relative links exist, the skill inventory matches the table, the introduction describes the collection, and exactly one invocation prompt appears.
- Passed: checked balanced code fences, Markdown table syntax, and absence of trailing whitespace; manually reviewed heading spacing and documentation and MIT license links.

## Unresolved Issues
- None.
