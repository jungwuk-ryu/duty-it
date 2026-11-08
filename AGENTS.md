# Agent Guidelines

## Flutter UI

- Before adding a widget, search `lib/app/widgets/` and screens that already offer the same interaction. Reuse the existing widget when it fits.
- For a small difference, use the widget's existing options or add a focused option that preserves its current behavior for other callers. If two screens need the same feature widget, move it to a shared location instead of copying it.
- Follow the surrounding screen's spacing, typography, and interaction patterns. Add labels, badges, or helper text only when they help the user understand or perform an action.

## Commits

- After every task that changes files, create a commit before finalizing the response unless the user explicitly asks not to commit or a blocking condition prevents committing.
- Use conventional atomic commits.
- Keep each commit focused on one logical change and avoid mixing unrelated edits.
- If a task contains multiple logical changes, split them into separate atomic commits before finalizing.
- Write commit messages using the Conventional Commits format, such as `feat(job): add bookmark tab` or `fix(job): hide map preview`.
