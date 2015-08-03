#!/bin/bash

#
# ghq-foreach - executes git subcmd or shell cmd for each repo managed by ghq
#

EXEC=
QUIET=

say() {
    [[ -n "$QUIET" ]] && return
    if [[ -t 1 ]]; then
        printf '\e[1;34m%s\e[m\n' "$1"
    else
        printf '%s\n' "$1"
    fi
}

main() {
    if [[ "$1" = "-q" ]]; then
        QUIET=1
        shift
    fi
    if [[ "$1" = "-e" ]]; then
        EXEC=1
        shift
    fi

    if [[ "$#" -eq 0 ]]; then
        echo "usage: ghq-foreach [-q] (<git-cmd> | -e <shell-cmd>) [args...]" >&2
        echo "    -e  Execute shell command" >&2
        echo "    -q  Don't print each repository path" >&2
        return 1
    fi

    ghq list -p | while read -r repo; do
        (
            cd "$repo"
            say "> $repo"
            if [[ -n "$EXEC" ]]; then
                "$@"
            else
                git "$@"
            fi
        )
    done
}

main "$@"