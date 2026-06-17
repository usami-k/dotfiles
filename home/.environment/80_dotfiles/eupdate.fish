#!/usr/bin/env fish

if not type --query homeshick
    echo 'Skip homeshick'
    exit 0
end

for repo_dir in ~/.homesick/repos/*/
    set -l castle (basename $repo_dir)
    pushd $repo_dir
    homeshick --batch pull $castle
    popd
end

homeshick --batch --force link
