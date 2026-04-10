---
name: pr-description
description: "Genera una descripción detallada de los cambios realizados en el código, destacando las modificaciones en la arquitectura, la lógica de negocio y la estructura de los estados."
---

When writing a PR description:

1. Run `git diff main...HEAD` to see all changes on this branch
2. Squash all commits into the branch to clean up the commit history and make it easier to understand the changes. Use `git rebase -i main` or `git reset --soft HEAD~{n}` to squash commits.
3. Write a description following this format:

## What
One sentence explaining what this PR does.

## Why
Brief context on why this change is needed

## Changes
- Bullet points of specific changes made
- Group related changes together
- Mention any files deleted or renamed
- Highlight any architectural changes (e.g. new layers, refactoring)
