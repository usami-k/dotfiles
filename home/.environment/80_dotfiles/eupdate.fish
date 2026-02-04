#!/usr/bin/env fish

if type --query homeshick
    homeshick --batch pull
    homeshick --batch --force link
else
    echo 'Skip homeshick'
end

set -l backups ~/.claude.json.backup.*
if test (count $backups) -gt 0
    trash $backups
end
