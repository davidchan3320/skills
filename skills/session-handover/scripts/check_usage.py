#!/usr/bin/env python3
"""Read usage metadata from this Codex thread only; never print session content."""

import json
import math
import os
import re
from datetime import datetime, timezone
from pathlib import Path


def number(value):
    return type(value) in (int, float) and math.isfinite(value)


def summarize(event, now):
    observed = event.get("timestamp")
    try:
        age = now - datetime.fromisoformat(observed.replace("Z", "+00:00")).timestamp()
    except (AttributeError, TypeError, ValueError, OverflowError):
        age = None
    fresh = age is not None and 0 <= age <= 300
    limits = event["payload"]["rate_limits"]
    windows = []
    for key in ("primary", "secondary"):
        window = limits.get(key)
        if not isinstance(window, dict):
            continue
        duration = window.get("window_minutes")
        used = window.get("used_percent")
        reset = window.get("resets_at")
        valid = fresh and number(used) and number(reset) and reset > now
        remaining = max(0, min(100, 100 - used)) if valid else None
        windows.append({
            "window_minutes": duration,
            "remaining_percent": remaining,
            "resets_at_unix": reset,
            "threshold_reached": remaining <= 5 if valid and duration in (300, 10080) else None,
        })
    return {"limit_id": limits.get("limit_id"), "observed_at": observed,
            "fresh": fresh, "windows": windows}


def check_usage(home, thread_id, now):
    # Reject globs/path separators so discovery cannot reach unrelated threads.
    if not thread_id or not re.fullmatch(r"[A-Za-z0-9_-]+", thread_id):
        return {"status": "unknown", "reason": "No valid current thread ID"}
    paths = list((home / "sessions").rglob(f"rollout-*-{thread_id}.jsonl"))
    if len(paths) != 1:
        return {"status": "unknown", "reason": "Current rollout missing or ambiguous"}
    latest = {}
    try:
        with paths[0].open(encoding="utf-8") as stream:
            for line in stream:
                try:
                    event = json.loads(line)
                except ValueError:
                    continue  # A concurrent append may leave an incomplete last line.
                if not isinstance(event, dict) or event.get("type") != "event_msg":
                    continue
                payload = event.get("payload")
                if not isinstance(payload, dict) or payload.get("type") != "token_count":
                    continue
                limits = payload.get("rate_limits")
                if not isinstance(limits, dict) or not limits:
                    continue
                bucket = limits.get("limit_id")
                if bucket is not None and not isinstance(bucket, str):
                    continue
                latest[bucket] = event
    except (OSError, UnicodeError):
        return {"status": "unknown", "reason": "Current rollout unreadable"}
    if not latest:
        return {"status": "unknown", "reason": "No rate-limit snapshot in current rollout"}
    buckets = [summarize(event, now) for event in latest.values()]
    known = any(w["threshold_reached"] is not None for b in buckets for w in b["windows"])
    return {"status": "observed" if known else "unknown",
            "source": str(paths[0]), "buckets": buckets}


if __name__ == "__main__":
    home = Path(os.environ.get("CODEX_HOME") or Path.home() / ".codex")
    thread_id = os.environ.get("CODEX_THREAD_ID") or os.environ.get("CODEX_SESSION_ID")
    print(json.dumps(check_usage(home, thread_id, datetime.now(timezone.utc).timestamp()), indent=2))
