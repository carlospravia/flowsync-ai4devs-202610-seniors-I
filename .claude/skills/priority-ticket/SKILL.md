---
name: priority-ticket
description: Fetch the highest-priority Jira ticket assigned to Carlos Pravia in "To Do", summarize its acceptance criteria, enter plan mode to propose an implementation, and move the ticket to "In Progress" once the plan is approved. Use when the user runs /priority-ticket or asks for the next ticket to work on.
disable-model-invocation: true
---

# Priority ticket

Uses the Atlassian MCP server configured in `.mcp.json` (tools named `mcp__atlassian__*`; the claude.ai connector `mcp__claude_ai_Atlassian_MCP__*` exposes the same operations). Load tool schemas with ToolSearch first if they are deferred.

## 1. Fetch the ticket

1. Call `getAccessibleAtlassianResources` once to get the `cloudId` (skip if already known).
2. Call `searchJiraIssuesUsingJql` with:
   ```
   assignee = currentUser() AND status = "To Do" ORDER BY priority DESC, created ASC
   ```
   Limit to 1 result. `currentUser()` is Carlos Pravia; if `atlassianUserInfo` says otherwise, stop and tell the user.
3. If nothing comes back, say so (mention the JQL used) and stop. Do not guess another ticket or status.
4. Call `getJiraIssue` on the key for the full description and fields. Use `view: full` if the description is missing from the compact view.

## 2. Summarize

Reply briefly with: key, title, priority, and the **acceptance criteria** as a short list. If the ticket has no explicit acceptance criteria, say so and derive them from the description, labelled as derived.

## 3. Plan

Call `EnterPlanMode`. Then, read-only:

- Read `CLAUDE.md` and explore the relevant code. Where the ticket touches an API endpoint, read the real backend controller/validator: tickets are product-level and often omit fields the backend requires. Flag every such gap in the plan.
- Propose the implementation: files to create/modify (counted), the order of work, how each acceptance criterion is satisfied, and open questions or risks.
- Do not edit files or transition the ticket while in plan mode.

Present the plan with `ExitPlanMode`.

## 4. After the plan is approved

Only if the user approves the plan:

1. Call `transitionJiraIssue` to move the ticket to **"In Progress"**. If the transition name differs, look up the available transitions for the issue and pick the one whose target status is "In Progress".
2. Confirm in one line: `KEY moved to In Progress`.
3. Do not start implementing unless the user asks; the exercise compares plans, not code.

If the plan is rejected, leave the ticket in "To Do".
