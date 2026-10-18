# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Context

FlowSync is the practice project for the "harness engineering" exercise of the LIDR AI4Devs course (see `README.md`, in Spanish). Two independent apps live side by side:

- `backend/` — AdonisJS 7 API (TypeScript, Lucid ORM, SQLite via better-sqlite3). **Already complete; do not modify it** unless explicitly asked. Read it to learn what the API requires.
- `frontend/` — React 19 + Vite 8 + TypeScript, still the bare Vite template. This is where feature work happens (the exercise ticket is "Implement login in the frontend", using shadcn/ui).

`prompts.md` at the root is a deliverable (log of prompts launched, verbatim); `README.md` is generated from the course lesson.

## Commands

Node **>=24** is required (`.nvmrc` pins it). With Node 20 the backend fails with `Unknown file extension ".ts"`. After switching Node versions run `nvm use` and `npm rebuild better-sqlite3` in `backend/`.

Backend (`cd backend`):
```bash
cp .env.example .env && node ace generate:key   # first time only
node ace migration:run
npm run dev          # http://localhost:3333 (ace serve --hmr)
npm test             # node ace test
node ace test functional                     # one suite (unit | functional)
node ace test --files tests/functional/x.spec.ts   # one file
node ace test --tests "test title"           # one test by title
npm run lint | npm run typecheck | npm run format
```

Frontend (`cd frontend`, run in a separate terminal from the backend):
```bash
npm run dev          # http://localhost:5173 (launch.json uses --strictPort)
npm run build        # tsc -b && vite build
npm run lint         # oxlint (not ESLint)
```
The frontend has no test runner. Prettier is installed in `frontend/` and runs automatically on `frontend/src/**` through the PostToolUse hook in `.claude/settings.json`; it is not wired to an npm script.

## Backend architecture

- **Routes** (`start/routes.ts`): all API routes live under `/api/v1`. `auth/signup` and `auth/login` are public; `account/profile` and `account/logout` sit behind `middleware.auth()`.
- **Controllers** are referenced through the generated `#generated/controllers` barrel (e.g. `controllers.AccessTokens`), not imported by path. Subpath imports (`#models/*`, `#validators/*`, `#transformers/*`, …) are defined in `package.json` `imports`.
- **Responses** go through `serialize(...)` and `UserTransformer`; `providers/api_provider.ts` registers a serializer that wraps every payload in `{ data: ... }`. Frontend code must unwrap `data`. Login returns `{ data: { user, token } }`.
- **Auth** is the access-token guard (`access_tokens` table); tokens are prefixed `oat_` and sent as `Authorization: Bearer <token>`. Logout deletes the current token.
- **Validators** (`app/validators/user.ts`, VineJS) are the source of truth for request shape and are stricter than the product ticket implies: signup requires `fullName` (nullable, but the key must be present), `email` (unique, max 254), `password` (8–32 chars) and `passwordConfirmation` (must match). Read the validator before building forms against an endpoint.
- **Database**: schema changes only via new migrations in `database/migrations/`, never by editing tables. `database/schema.ts` is generated from migrations.
- **CORS**: wide open in dev (`origin: true`), empty allowlist in production (`config/cors.ts`), so the Vite dev server can call the API directly on :3333.
- **Tests**: Japa; suites `unit` (`tests/unit/**`) and `functional` (`tests/functional/**`, starts the HTTP server). `.env.test` uses `SESSION_DRIVER=memory`. No spec files exist yet — only `tests/bootstrap.ts`.

## Process rules

1. **Branch first.** Before touching any code, create a new branch off the current one (`git checkout -b <type>/<short-description>`). Never commit on `main` or on the course branches (`s1/start`).
2. **Closing the work.** When the implementation is done:
   1. Stage the changes and run `/commit` (conventional commit).
   2. Push the branch and open the pull request with `gh pr create`.
3. **Review.** After the PR exists, run the `adversarial-reviewer` subagent on it, passing the PR number or URL.
4. **Chat output.** In the chat, reply with only the pull request URL. No summary, no review findings, no explanation.
