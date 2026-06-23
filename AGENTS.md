# Agent Guidelines

## Sub-Agent Review

- For every non-trivial task, request a review from exactly one sub-agent before finalizing the work.
- Ask the sub-agent to review security risks, performance risks, and improvement opportunities.
- Address actionable findings before finishing, or clearly document why a finding was deferred.

## Commits

- After every task that changes files, create a commit before finalizing the response unless the user explicitly asks not to commit or a blocking condition prevents committing.
- Use conventional atomic commits.
- Keep each commit focused on one logical change and avoid mixing unrelated edits.
- If a task contains multiple logical changes, split them into separate atomic commits before finalizing.
- Write commit messages using the Conventional Commits format, such as `feat(job): add bookmark tab` or `fix(job): hide map preview`.
