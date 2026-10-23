#!/usr/bin/env fish

if not type --query brew
    echo 'Skip cask-outdated'
    exit 0
end

set -l outdated (brew outdated --cask --greedy-auto-updates --verbose)
or exit

if test (count $outdated) -gt 0
    echo 'eupdate full で入れ替わる cask（急ぐものは brew upgrade --cask <名前>）:'
    printf '  %s\n' $outdated
end
