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
| `infra/main.tf`: a database and a volume declared encrypted, a KMS key | `github.iac-storage-encrypted` | pass: storage declared encrypted at rest |
| `infra/main.tf`: a security group open to the internet on 443 only | `github.iac-no-open-ingress` | pass: nothing open but web traffic |
| `.github/workflows/release.yml`: attests build provenance, actions pinned to a commit, a read-only token (runs only by hand) | `github.build-provenance` | pass: the build attests its provenance |
| Release `v1.0.0` with `dist.tgz` and its signed provenance `dist.tgz.intoto.jsonl` | `github.release-attestations` | pass: the release carries a signed attestation |
| `.github/workflows/ci.yml` on pull requests, and the ruleset's required `test` check | `github.tests-before-merge` | pass: tests must pass before a merge |
| Every job on GitHub-hosted runners | `github.hosted-runners` | pass: builds start clean |
| `release.yml` makes an SBOM (`anchore/sbom-action`), and release `v1.0.0` carries `dist.tgz.spdx.json` | `github.sbom-generated`, `github.release-sbom` | pass: the build makes an SBOM, the release ships one |
| `infra/main.tf`: HTTPS listener and an HTTP→HTTPS redirect; a multi-region CloudTrail with log validation; S3 object lock in COMPLIANCE mode; a lifecycle that expires uploads | `github.iac-tls-in-transit`, `github.iac-cloudtrail`, `github.iac-object-lock`, `github.iac-lifecycle-expiry` | pass |
| `ci.yml` checks `infra/` with Checkov | `github.iac-policy-gate` | pass |
