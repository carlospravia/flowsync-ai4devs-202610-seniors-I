---
name: commit
description: Create a conventional commit (type(scope): description) from the currently staged changes. Use when the user runs /commit or asks to commit staged work.
disable-model-invocation: true
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*)
---

# Commit

Create ONE conventional commit from the **staged** changes only.

## Steps

1. Run `git status --short` and `git diff --staged`. Do not run `git add`: the user decides what is staged.
2. If nothing is staged, say so and stop. Do not stage files on the user's behalf.
3. Run `git log -5 --oneline` to match the repo's existing style.
4. Write the message as `type(scope): description`:
   - **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`.
   - **scope**: the area touched, e.g. `frontend`, `backend`, `auth`, `harness`. Omit it only if the change spans unrelated areas.
   - **description**: imperative mood, lowercase, no trailing period, max ~72 chars total on the first line.
   - Add a body (blank line, then wrapped text) only when the *why* is not obvious from the diff. Mark breaking changes with `!` and a `BREAKING CHANGE:` footer.
5. If the staged diff mixes unrelated concerns, tell the user and suggest splitting rather than writing a vague message.
6. Commit with `git commit -m "<message>"` (use a heredoc for multi-line bodies).
7. Reply with the commit hash and subject line only.

## Rules

- Never add `Co-Authored-By` or any AI attribution to the message.
- Never use `--no-verify`, `--amend`, or `git push`. If a hook fails, show the error and fix the cause; do not bypass it.
- Message language: English.
