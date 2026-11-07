# cajex-evidence-impl-pass

Fixture repository for cajeX's GitHub check templates (Live Evidence RFC 20, tracks B and E).
It **passes** every check: each file here is what a well-run repository has.

cajeX's conformance kit reads it through the *cajeX Evidence (sandbox)* GitHub App, read-only,
and every catalogue template is held to the answer it must give here
(`catalogue/checks/github/*.yaml`, `fixtures:`). Its twin, `cajex-evidence-impl-fail`,
gives the opposite answer.

Nothing here is built, run or secret. Files arrive by pull request from the cajeX repository's
template work, each with the template it proves. Please leave them as they are.

## What is here on purpose

| File | Template | Meant to |
|---|---|---|
| `.github/CODEOWNERS`, and a ruleset on `main` requiring code-owner review | `github.code-owners` | pass: owners are named and their review is required |
| `.github/dependabot.yml` (npm and GitHub Actions, weekly) | `github.dependency-updates` | pass: dependency updates are on |
| `src/index.js`, with code scanning (CodeQL default setup) on | `github.code-scanning-remediation` | pass: code scanning runs and finds nothing overdue |
| Collaborators: the owner alone | `github.privileged-access` | pass: one admin, no outside collaborator who can write |
