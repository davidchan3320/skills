# Expand the README workflow guide

- **Status:** Completed
- **Created:** 2026-09-07 12:58+08:00
- **Last updated:** 2026-09-07 12:59+08:00
- **Supersedes:** None
- **Current blocker:** None
- **Next action:** None — implementation and required verification complete

## Goal
Expand readme.md so users understand how to save, resume, revise, and complete a plan using Plan Handoff.

## Implementation Changes
- Retain the introduction, installation commands, skill link, and MIT license section.
- Clarify that example handoff paths are illustrative and must be replaced with the actual saved path.
- Add a Workflow section covering finalized or approved plans, deferred writes during planning, explicit-path resumption and ambiguity, milestone tracking in the same file with an append-only progress log, and revisions in a new handoff linked to its predecessor with relevant progress and unresolved work carried forward.
- Include a compact status table for Ready, In progress, Blocked, and Completed, including resumption after blockers clear.
- Explain the completion gate: all implementation milestones and required verification pass, no blockers remain, and unresolved issues are resolved or explicitly optional follow-up.
- Keep filename conventions in Quick start and link to the skill for the full handoff template.

## Interfaces and Types
None. No API changes.

## Tests
- Review all workflow claims against skills/plan-handoff/SKILL.md.
- Verify Markdown headings, table formatting, code fences, and relative links.
- Confirm example paths are illustrative and installation commands remain accurate.
- Automated tests are not required for this documentation-only change.

## Assumptions
- Skill behavior remains unchanged.
- The supplied plan specifies this handoff path; save it as the first write when execution is permitted, using a numeric suffix if occupied.
- Track implementation and verification here through completion. No files are written during Plan Mode.

## Milestones
- [x] Expand README while preserving existing introduction, installation, and license.
- [x] Verify workflow accuracy and Markdown structure.

## Progress Log
- 2026-09-07 12:58+08:00 — Finalized plan saved with status `Ready`.
- 2026-09-07 12:58+08:00 — Implementation started; next action is to expand the README.
- 2026-09-07 12:59+08:00 — Expanded README with workflow steps, status table, completion gate, illustrative-path guidance, and template link; preserved introduction, installation commands, and license.
- 2026-09-07 12:59+08:00 — Verification passed: reviewed workflow claims against the repository skill and checked Markdown structure, links, and installation commands.
- 2026-09-07 12:59+08:00 — Completion gate passed; all milestones and required checks complete, with no blockers or unresolved issues. Status set to `Completed`.

## Verification Results
- Passed: manual comparison of every Workflow step, status-table row, filename convention, and completion requirement against skills/plan-handoff/SKILL.md.
- Passed: Python read-only assertions verified the four expected Markdown headings, paired shell code fences, six table rows with two columns, relative file links and the create-a-handoff anchor, and explicit illustrative-path wording.
- Passed: exact installation-command comparison confirmed the original mkdir and cp commands are unchanged and the source skill directory exists.
- Passed: manual review confirmed the introduction, skill link, and MIT license section are retained.
- Automated application tests: not required by the documentation-only plan.

## Unresolved Issues
None.
