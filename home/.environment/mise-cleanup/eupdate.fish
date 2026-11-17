#!/usr/bin/env fish

if not type --query --no-function mise
    echo 'Skip mise'
    exit 0
end

# mise ignores tracked files on disconnected disks. Inspect the tracking links
# before pruning so their tools are not mistaken for unused installations.
function check_tracked_volumes
    set -l state_dir "$HOME/.local/state/mise"
    if set -q XDG_STATE_HOME; and test -n "$XDG_STATE_HOME"
        set state_dir "$XDG_STATE_HOME/mise"
    end
    if set -q MISE_STATE_DIR; and test -n "$MISE_STATE_DIR"
        set state_dir "$MISE_STATE_DIR"
    end

    set -l volumes
    for kind in tracked-configs tracked-stubs
        set -l directory "$state_dir/$kind"
        if test -e "$directory"
            if not test -d "$directory"; or not test -r "$directory"; or not test -x "$directory"
                echo "mise-cleanup: cannot read tracking directory: $directory" >&2
                return 1
            end
        end
        for entry in "$directory"/*
            test -L "$entry"; or continue
            set -l target (command readlink "$entry"); or return
            if string match --quiet '/Volumes/*/*' -- "$target"
                set -l volume (string replace --regex '^(/Volumes/[^/]+).*' '$1' -- "$target")
                contains -- "$volume" $volumes; or set --append volumes "$volume"
            end
        end
    end

    if test (count $volumes) -gt 0
        set -l mounts (command mount); or return
        for volume in $volumes
            set -l escaped (string escape --style=regex -- "$volume")
            if not string match --quiet --regex -- " on $escaped( \\(| type )" $mounts
                echo "mise-cleanup: tracked volume is not mounted: $volume; no tools were pruned" >&2
                return 1
            end
        end
    end
end

check_tracked_volumes; or exit

set -g preview (mktemp); or exit
function cleanup --on-event fish_exit
    command rm -f -- "$preview"
end

# Keep warnings visible even if the caller normally silences mise output.
set -lx MISE_COLOR 0
set -lx MISE_LOG_LEVEL info
set -lx MISE_QUIET false
set -lx MISE_SILENT false

command mise prune --tools --dry-run >"$preview" 2>&1
set -l preview_status $status
command cat "$preview"
if test $preview_status -ne 0
    exit $preview_status
end
if string match --quiet --ignore-case --regex '(^|[[:space:]])(warn(ing)?|error)([[:space:]:]|$)' <"$preview"
    echo 'mise-cleanup: preview reported a warning or error; no tools were pruned' >&2
    exit 1
end

# Recheck just before the destructive command, which performs its own fresh
# scan of references and running processes. Leave config tracking intact.
check_tracked_volumes; or exit
command mise prune --tools --yes >"$preview" 2>&1
set -l prune_status $status
command cat "$preview"
if test $prune_status -ne 0
    exit $prune_status
end
if string match --quiet --ignore-case --regex '(^|[[:space:]])(warn(ing)?|error)([[:space:]:]|$)' <"$preview"
    echo 'mise-cleanup: prune reported a warning or error; check the output above' >&2
    exit 1
end
