#!/usr/bin/env fish

set --global original_dir (pwd)
set --global current_dir (realpath (dirname (status filename)))

if test (count $argv) -gt 1
    echo 'Usage: eupdate [full|light]' >&2
    exit 64
end

set -l mode full
if test (count $argv) -eq 1
    set mode $argv[1]
end

set -l steps
switch $mode
    case full
        set steps \
            homebrew \
            backup \
            development-tools \
            ccpocket \
            texlive \
            shell \
            macos-settings \
            homeshick \
            repositories
    case light
        set steps \
            backup \
            homeshick \
            repositories
    case -h --help
        echo 'Usage: eupdate [full|light]'
        exit 0
    case '*'
        printf 'eupdate: unknown mode: %s\n' $mode >&2
        echo 'Usage: eupdate [full|light]' >&2
        exit 64
end

set -l run_started_at (date '+%Y-%m-%dT%H:%M:%S%z')
set -l run_started_seconds (date +%s)
set -l run_result success
set -l run_exit_code 0
set -l failed_steps

echo "### RUN START mode=$mode started_at=$run_started_at"

cd $current_dir
for step in $steps
    set -l script ./$step/eupdate.fish
    if not test -x $script
        echo "### STEP SKIP name=$step reason=missing_or_not_executable"
        continue
    end

    set -l step_started_at (date '+%Y-%m-%dT%H:%M:%S%z')
    set -l step_started_seconds (date +%s)
    echo "### STEP START name=$step started_at=$step_started_at"
    $script
    set -l step_exit_code $status
    set -l step_finished_at (date '+%Y-%m-%dT%H:%M:%S%z')
    set -l step_elapsed_seconds (math (date +%s) - $step_started_seconds)

    if test $step_exit_code -eq 0
        printf '\n### STEP END name=%s result=success exit_code=0 elapsed_seconds=%s finished_at=%s\n' $step $step_elapsed_seconds $step_finished_at
        continue
    end

    set --append failed_steps $step
    printf '\n### STEP END name=%s result=failed exit_code=%s elapsed_seconds=%s finished_at=%s\n' $step $step_exit_code $step_elapsed_seconds $step_finished_at

    if test $step_exit_code -eq 130 -o $step_exit_code -eq 143
        set run_result interrupted
        set run_exit_code $step_exit_code
        break
    end

    set run_result partial
    set run_exit_code 1
end
cd $original_dir

set -l run_finished_at (date '+%Y-%m-%dT%H:%M:%S%z')
set -l run_elapsed_seconds (math (date +%s) - $run_started_seconds)
set -l failed_step_names (string join , $failed_steps)
echo "### RUN END mode=$mode result=$run_result exit_code=$run_exit_code elapsed_seconds=$run_elapsed_seconds finished_at=$run_finished_at failed_steps=$failed_step_names"

switch $run_result
    case success
        echo '### Done'
    case partial
        echo '### Partial'
    case interrupted
        echo '### Interrupted'
end

date
exit $run_exit_code
