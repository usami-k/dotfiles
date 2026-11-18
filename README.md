dotfiles
========

dotfiles with [homeshick](https://github.com/andsens/homeshick).

## Link layout

Use real directories under the home directory and let homeshick create links
for individual tracked files. Do not manually link a parent directory into a
castle, for example `~/.scripts/notification -> .../home/.scripts/notification`.
With homeshick 2.0.1, `homeshick --batch --force link` can follow that parent
link and replace the original files in the castle with self-referencing links.
It may still exit successfully.

To repair this layout, inspect both the working-tree and staged diffs first,
restore only the damaged source files from a verified revision, unlink only the
parent symlink, and create a real directory in its place. Then create per-file
links to the castle. Never recursively delete the linked directory. Check the
source contents, executable permissions, and working-tree diff after linking;
`homeshick check` alone does not prove that the files or links are intact.

`mise run test:homeshick-links` reproduces the directory-link failure and
verifies the repaired layout through two runs of the actual homeshick update
step. It uses a disposable home and stubs pull/check, so it does not update real
castles or contact remotes. The update step's parent preflight check remains
removed; the supported layout is real directories with per-file links.
