# Shared failure reporting for update steps. No retries or output parsing.
set -g eupdate_exit_code 0

function eupdate_run
    $argv
    set -l code $status
    if test $code -ne 0
        printf '\neupdate: command failed (exit=%s): %s\n' $code (string join ' ' -- $argv) >&2
        if contains -- $code 130 143
            exit $code
        end
        set -g eupdate_exit_code 1
    end
    return $code
end
