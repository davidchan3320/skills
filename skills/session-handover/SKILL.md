---
name: session-handover
description: Create or update a handover document capturing the current session's objective, completed work, verified state, unresolved issues, and next steps so another person or agent can continue. Use when asked to document session work for handover, preserve context before switching sessions, or prepare continuation notes. Also use proactively when a usage limit is reported or verified remaining usage is 5% or less during unfinished work.
---

# Session Handover

Write a self-contained document that lets the next person or agent resume without reconstructing the conversation. Default to Markdown unless the user requests another format.

## Usage-limit handover

During unfinished work, create or refresh the handover when an actual usage-limit warning or error is reported, or a reliable usage reading shows 5% or less remaining in an applicable usage window. A user's report that the limit has been reached also triggers a handover; attribute it to the user if it cannot be verified.

When usage tools are available, check at natural checkpoints during sustained work and after a usage warning. In Codex, use `get_usage_limits` when available. Prefer `rateLimitsByLimitId` over the legacy view and use the bucket applicable to the current model; for its five-hour and weekly windows, compute remaining percentage as `max(0, min(100, 100 - usedPercent))`. Either window at 5% or below qualifies. Missing values mean unknown, not zero. Do not confuse token context capacity with account usage or infer a percentage from task length.

Once triggered, prioritize saving a concise handover before starting another substantial operation. Record the trigger, when it was observed, the affected usage window, and any reported reset time with its timezone. Capture in-progress operations and the immediate next action. Reuse the same document and update it after meaningful progress rather than creating repeated snapshots of unchanged state. Saving a handover does not itself pause or cancel the user's task.

A skill is not a background monitor or a guaranteed shutdown hook. If execution has already been blocked, a file may no longer be writable; never claim a handover was saved without a successful write. Do not consume reset credits or schedule automatic resumption solely because this trigger fired.

## Establish the actual state

Use the current conversation and relevant workspace artifacts as the primary sources. Preserve the original objective, later corrections, accepted decisions, constraints, and work still outstanding. Distinguish completed work from proposed work and observed results from assumptions.

Inspect only the files and tool results needed to establish the current state. For repository work, check the working directory, branch, current commit, and relevant staged, unstaged, and untracked changes. Do not attribute unrelated existing changes to this session. Record the latest meaningful validation and any subsequent edits that have not been checked.

If earlier history is unavailable, state that limitation and identify what needs verification. Do not invent missing progress or inspect unrelated sessions to fill gaps. Omit secrets and credential values; reference their configured location only when needed for continuation.

## Write the handover

Honor the user's requested destination and existing project conventions. Otherwise save `session-handover.md` in the workspace's designated deliverables directory, or the workspace root if none exists. Update an existing document only when it covers the same work; use a task-specific filename when needed to avoid overwriting a different handover.

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
