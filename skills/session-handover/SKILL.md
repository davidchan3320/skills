---
name: session-handover
description: Check account usage at the start of sustained work and at progress checkpoints; save a session handover when the five-hour (300-minute) or weekly allowance has 5% or less remaining (95% or more used), or a usage warning is reported. Also use for explicit session handover and continuation notes.
---

# Session Handover

Write a self-contained document that lets the next person or agent resume without reconstructing the conversation. Default to Markdown unless the user requests another format.

## Usage-limit handover

Load this skill and check usage at the start of sustained work, even when no warning has appeared. Recheck at meaningful progress checkpoints and before starting another substantial operation. This initial check is needed because the threshold cannot select an unloaded skill when usage is not exposed in the conversation. A check above the threshold does not require creating a handover.

During unfinished work, create or refresh the handover when an actual usage-limit warning or error is reported, or a reliable usage reading shows 5% or less remaining in an applicable usage window. A user's report of 5% or less remaining or a reached limit also triggers a handover; attribute it to the user if it cannot be verified. Do not wait for an exhausted-limit error.

Read usage in this order:

1. Use `get_usage_limits` if exposed, or an available client integration for Codex's `account/rateLimits/read`. Prefer `rateLimitsByLimitId` over the legacy view and use the bucket applicable to the current model.
2. If no live usage tool is available, run `python3 <skill-directory>/scripts/check_usage.py`, resolving `<skill-directory>` from this SKILL.md's path. It reads only the current thread's rollout under the active `CODEX_HOME` and outputs usage metadata, without printing conversation content or reading credentials. It uses `CODEX_THREAD_ID` (or `CODEX_SESSION_ID`); never substitute another account's or thread's log.
3. If usage is unknown, say once that automatic threshold detection is unavailable and continue the authorized task. Honor any explicit user-reported low allowance. Do not invent a reading or claim monitoring is active.

Identify windows by duration: 300 minutes is five hours, 10080 is weekly. Compute remaining percentage as `max(0, min(100, 100 - usedPercent))`; local logs use `used_percent`. Either applicable window at 5% or below qualifies, including exactly 5%. For example, 95% used triggers; 5% used means 95% remaining and does not trigger. Missing values mean unknown, not zero. Do not confuse token context capacity, elapsed wall time, or time until reset with account usage. The fallback returns separate buckets; do not select an unrelated model's bucket. Stale readings (over five minutes old), readings past their reset, or ambiguous bucket applicability cannot establish current remaining usage; prefer a fresh live reading when available.

Once triggered, prioritize saving a concise handover before starting another substantial operation. Record the trigger, when it was observed, the affected usage window, and any reported reset time with its timezone. Capture in-progress operations and the immediate next action. Update this session's handover after meaningful progress rather than creating repeated snapshots of unchanged state. Saving a handover does not itself pause or cancel the user's task.

A skill is not a background monitor or a guaranteed shutdown hook. If execution has already been blocked, a file may no longer be writable; never claim a handover was saved without a successful write. Do not consume reset credits or schedule automatic resumption solely because this trigger fired.

## Establish the actual state

Use the current conversation and relevant workspace artifacts as the primary sources. Preserve the original objective, later corrections, accepted decisions, constraints, and work still outstanding. Distinguish completed work from proposed work and observed results from assumptions.

Inspect only the files and tool results needed to establish the current state. For repository work, check the working directory, branch, current commit, and relevant staged, unstaged, and untracked changes. Do not attribute unrelated existing changes to this session. Record the latest meaningful validation and any subsequent edits that have not been checked.

If earlier history is unavailable, state that limitation and identify what needs verification. Do not invent missing progress or inspect unrelated sessions to fill gaps. Omit secrets and credential values; reference their configured location only when needed for continuation.

## Write the handover

Honor a destination or filename explicitly requested by the user. Otherwise save the handover in the workspace's designated deliverables directory, or the workspace root if none exists, as `YYYY-MM-DD-HHMM-topic-handover.md`. Use the local date and time when this session's handover is first written, and derive a short lowercase hyphenated topic from the task. If that name already belongs to another session, add the first available numeric suffix before `.md`, starting with `-2`.

Keep one file for the current session: subsequent updates to its handover use that same path, even when its updated timestamp changes. A later session gets a new file, even when it continues the same task. Do not reuse an earlier session's handover merely because its topic matches. If the user explicitly requests updating a particular existing file, honor that request.

If you encounter an older generic handover for the current work, rename it using the timestamp recorded in that handover and a topic derived from its task, applying the same collision rule. Update direct references to its old path that you find in the relevant workspace. If that handover belongs to an earlier session, create a separate file for the current session. Leave unrelated handovers alone; do not bulk-migrate other workspaces.

Choose sections proportional to the work. Include the following when relevant:

- **Objective and scope:** The requested outcome and the conditions for completion.
- **Current status:** A dated snapshot of what is complete, in progress, blocked, or unverified.
- **Completed work:** Concrete changes and deliverables, with usable file paths or links and a short explanation of their purpose.
- **Decisions and constraints:** Choices that affect continuation, their rationale, and explicit user preferences or authorization boundaries.
- **Verification:** Checks actually performed, their outcomes, and remaining gaps. Include commands and working directories when useful for reproduction; distinguish checks not run from checks that failed.
- **Open issues:** Known failures, unresolved questions, attempted approaches that matter, and evidence needed to resolve them.
- **Next actions:** Ordered, executable steps, beginning with the immediate next action. State dependencies and completion criteria without treating a proposal as approved.
- **Continuation context:** Relevant repository state, artifact locations, external references, and active processes or pending operations. Identify temporary session IDs as potentially expired and explain how to recheck state before retrying an operation.

Omit empty sections and irrelevant environment detail. Summarize the final state rather than producing a transcript. A short session may need only a few paragraphs. If no substantive work preceded the handover request, say so plainly.

## Verify and deliver

Read the saved document and check factual claims against the available evidence. Confirm important local paths exist and that the next action follows from the recorded status. Flag uncertain or stale information rather than silently presenting it as current.

Return a link to the document and a brief statement of what it covers. Creating a handover does not itself authorize sending messages, creating another task, committing changes, deploying, or stopping active work; perform those actions only when separately requested or already authorized.
