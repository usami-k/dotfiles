#!/usr/bin/env fish

set -g step (path resolve $argv[1])
set -g homeshick_bin (command -s homeshick); or exit 1
set -g git_bin (command env PATH=/opt/homebrew/bin:/usr/bin:/bin which git); or exit 1
set -g fish_bin (status fish-path)
set -g fixture (command mktemp -d); or exit 1
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

set -g test_home "$fixture/home with spaces"
set -g repo "$test_home/.homesick/repos/example"
set -g source_dir "$repo/home/.scripts/notification"
set -g target_dir "$test_home/.scripts/notification"
command mkdir -p "$source_dir" "$test_home/.scripts" "$fixture/bin"; or exit 1
printf '%s\n' original-message >"$source_dir/message.jq"
printf '%s\n' '#!/bin/sh' 'exit 0' >"$source_dir/notify.fish"
command chmod +x "$source_dir/notify.fish"; or exit 1
printf '%s\n' castle-config >"$repo/home/.existing-config"
printf '%s\n' user-config >"$test_home/.existing-config"
printf '%s\n' new-config >"$repo/home/.new-config"
"$git_bin" init --quiet "$repo"; or exit 1
"$git_bin" -C "$repo" add home; or exit 1
command ln -s ../.homesick/repos/example/home/.scripts/notification "$target_dir"; or exit 1

# Reproduce the directory-alias bug only inside the disposable HOME.
command env HOME="$test_home" PATH=/opt/homebrew/bin:/usr/bin:/bin "$homeshick_bin" --batch --force link example >"$fixture/reproduction" 2>&1
or begin
    command cat "$fixture/reproduction" >&2
    exit 1
end
for name in message.jq notify.fish
    if not test -L "$source_dir/$name"; or test (command readlink "$source_dir/$name") != "$name"; or test -e "$source_dir/$name"
        echo "FAIL: did not reproduce the source self-link: $name" >&2
        exit 1
    end
end

# Repair the source and replace only the directory link, never its contents.
"$git_bin" -C "$repo" restore --worktree -- home/.scripts/notification; or exit 1
command rm "$target_dir"; or exit 1
command mkdir "$target_dir"; or exit 1
command rm "$test_home/.existing-config"; or exit 1
printf '%s\n' user-config >"$test_home/.existing-config"
command rm "$test_home/.new-config"; or exit 1

# Run the link step in isolation. The review command is covered by test:castle-review.
printf '%s\n' "#!$fish_bin --no-config" \
    'string join " " -- $argv >>"$TEST_CALLS"' \
    'if contains -- link $argv; or contains -- symlink $argv' \
    '    exec "$TEST_HOMESHICK" $argv' \
    end \
    'exit 0' >"$fixture/bin/homeshick"
printf '%s\n' '#!/bin/sh' 'exit 0' >"$fixture/bin/uv"
command chmod +x "$fixture/bin/homeshick" "$fixture/bin/uv"; or exit 1
command ln -s "$git_bin" "$fixture/bin/git"; or exit 1

for iteration in 1 2
    command env HOME="$test_home" TEST_HOMESHICK="$homeshick_bin" TEST_CALLS="$fixture/calls" PATH="$fixture/bin:/opt/homebrew/bin:/usr/bin:/bin" "$fish_bin" --no-config "$step" >"$fixture/output" 2>&1
    or begin
        command cat "$fixture/output" >&2
        exit 1
    end
    if test -L "$target_dir"; or not test -d "$target_dir"
        echo 'FAIL: notification parent must remain a real directory' >&2
        exit 1
    end
    for name in message.jq notify.fish
        if test -L "$source_dir/$name"; or not test -f "$source_dir/$name"; or not test -L "$target_dir/$name"
            echo "FAIL: wrong source or destination type: $name" >&2
            exit 1
        end
        command cmp "$source_dir/$name" "$target_dir/$name"; or exit 1
    end
    if not test -x "$source_dir/notify.fish"; or not test -x "$target_dir/notify.fish"
        echo 'FAIL: executable permission was lost' >&2
        exit 1
    end
    "$git_bin" -C "$repo" diff --exit-code; or exit 1
    if not test -L "$test_home/.new-config"; or test (command cat "$test_home/.new-config") != new-config
        echo 'FAIL: missing file was not linked' >&2
        exit 1
    end
    if not test -L "$test_home/.existing-config"; or test (command cat "$test_home/.existing-config") != castle-config
        echo 'FAIL: conflicting file was not replaced' >&2
        exit 1
    end
end
if test (count (string match -- '--batch --force link' (command cat "$fixture/calls"))) -ne 2
    echo 'FAIL: the real force-link command must run twice' >&2
    exit 1
end

echo 'PASS: isolated self-link reproduction, directory repair, two force-link runs, source content and executable mode, new links and conflict replacement'
