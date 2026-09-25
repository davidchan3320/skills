---
name: plan-handoff
description: Persist complete finalized plans as Markdown handoffs, record which model produced each plan, and keep the handoffs current while implementation proceeds. Use automatically when a plan is finalized or when implementation starts or continues from a saved plan; do not use for drafts or tentative planning.
---

# Plan Handoff

Maintain one durable, self-contained plan file from finalization through verified completion. The handoff must identify the planning model and preserve the full finalized plan, not a summary or pointer back to the conversation. Record progress at meaningful milestones, not after every command.

## Choose the operating path

- **Finalizing a plan:** Save it only once it is the final plan being delivered or the user has approved it. Never persist intermediate drafts, alternatives still under discussion, or rendering-only `<proposed_plan>` tags.
- **Implementing a plan:** Resolve the active handoff, mark implementation as started, and update that same file as work proceeds.
- **Revising a finalized plan:** Create a new handoff instead of overwriting the earlier plan. Identify the predecessor and carry forward relevant completed milestones and unresolved work.

If the current mode or another instruction prohibits writes while planning, include the intended handoff path in the final plan and state that saving it is the first action to take when execution is permitted. Do not attempt the write until then.

## Create a handoff

1. Resolve the project root from the user's explicit project location, otherwise the current repository root, otherwise the current working directory.
2. Use the machine's local time. Build `docs/plans/YYYY-MM-DD-HHMM-<title-slug>.md`, where the slug is a short lowercase hyphenated form of the plan title.
3. Never overwrite a collision. If that path exists, choose the first available numeric suffix before `.md`, starting with `-2`.
4. Create `docs/plans/`, including any missing parent directories, if needed. Do not add ignore rules; handoffs should remain visible and eligible for version control.
5. Omit `<proposed_plan>` and `</proposed_plan>` wrapper lines while preserving all Markdown content between them.
6. Record the exact model identifier that produced the finalized plan. Include its reasoning effort when that information is available, for example `gpt-6-sol (reasoning: high)`. If the exact identifier is unavailable, write `Unknown`; never infer it from writing style, capability, or context. For a revised handoff, record the model that produced the revision while leaving the predecessor unchanged.

Populate the plan-body sections with the complete finalized plan. Preserve every material heading, step, decision, file path, interface, code block, test, edge case, assumption, and constraint. Retain additional source-plan headings in their original order when the required structure does not already represent them. Do not shorten the plan, replace details with a synopsis, use ellipses as saved content, or refer the reader to chat history or another transient source. Wording and organization may be normalized to fit the handoff structure only when no information is lost.

Use this structure, adapting list detail to the plan while retaining every section:

```markdown
# <Plan title>

- **Status:** Ready
- **Created:** YYYY-MM-DD HH:MM ±HH:MM
- **Last updated:** YYYY-MM-DD HH:MM ±HH:MM
- **Planning model:** <exact model identifier> (reasoning: <effort>)
- **Supersedes:** None
- **Current blocker:** None
- **Next action:** <specific next action>

## Goal
...

## Implementation Changes
...

## Interfaces and Types
...

## Tests
...

## Assumptions
...

## Milestones
- [ ] ...

## Progress Log
- YYYY-MM-DD HH:MM ±HH:MM — Complete finalized plan saved with status `Ready`; planning model: `<exact model identifier>`.

## Verification Results
- Not run yet.

## Unresolved Issues
- None currently.
```

Use exactly one overall status: `Ready`, `In progress`, `Blocked`, or `Completed`. Write `None` explicitly when a required section or field has no entries. Keep `Planning model` unchanged after creation; it attributes the model that produced that handoff's finalized plan, not models that later implement it. A revised handoff must set `Supersedes` to a clear relative path or Markdown link to its predecessor, retain still-relevant checked milestones, copy unresolved work that remains applicable, and include the complete revised plan rather than only its delta from the predecessor.

## Resolve the active handoff

The `docs/plans/` default applies to new handoffs. Keep existing handoffs in place and resume them at their original paths.

Use an explicitly supplied plan path when present. Otherwise use current conversation context only when it identifies one handoff unambiguously. Before editing, verify the resolved file exists and is inside the intended project.

If multiple handoffs could reasonably be active, ask the user to confirm the path. Do not select by newest timestamp, filename order, or convenience. If no existing handoff can be resolved during implementation, say so and ask for the path rather than creating an unrelated replacement.

## Track implementation

At each event below, update mutable fields and append one concise timestamped entry to `Progress Log`:

- Implementation starts: change `Ready` to `In progress` and record the immediate next action.
- A plan item completes: check its milestone and record the result.
- Scope or a technical decision changes: update the affected plan sections, assumptions, milestones, or tests; log what changed and why.
- A blocker appears: set status to `Blocked`, fill `Current blocker`, and make `Next action` the concrete unblocking step.
- A blocker clears: set status back to `In progress`, clear `Current blocker` to `None`, and record the resumed action.
- Verification runs: add the exact command or check and its passed, failed, or skipped outcome under `Verification Results`; keep failures and skips visible and log the outcome.
- Implementation finishes: apply the completion gate below, then update the final status and next action.

Update `Last updated` at every such milestone. Treat `Progress Log` as append-only: never rewrite or remove earlier entries. Status fields, plan content, checkboxes, verification results, and unresolved issues may be updated as facts change, but retain historical failed or skipped verification entries.

## Enforce completion

Set `Completed` only when every required implementation milestone is checked, every required verification has passed, no blocker remains, and unresolved issues are either resolved or explicitly classified as non-required follow-up. A required failed, skipped, or unrun check prevents completion.

If the gate fails, keep `In progress` or `Blocked` as appropriate, state what remains in `Current blocker` or `Unresolved Issues`, set a concrete `Next action`, and append a log entry noting that completion was deferred. On successful completion, set `Current blocker` to `None`, set `Next action` to `None — implementation and required verification complete`, and append the completion entry.
