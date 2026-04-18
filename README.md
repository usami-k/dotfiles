dotfiles
========

dotfiles with [homeshick](https://github.com/andsens/homeshick).

## Workflow

This repository is managed with `jj`, but `homeshick check` looks at the
underlying Git branch state.

When committing with `jj`, use this order:

1. `jj describe -m "..."`
2. `jj bookmark set main -r @`
3. `jj new main`
4. `git switch main`
5. `homeshick check`

Do not run `git switch main` immediately after `jj describe`. If the `main`
bookmark is still pointing at the old commit, the new change disappears from
the working tree view.

When pushing to GitHub:

1. `jj git push --bookmark main --remote origin`
2. `git switch main`
3. `homeshick check`
