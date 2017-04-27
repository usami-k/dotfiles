# fish theme : deference

function __prompt_git_branch
    command git symbolic-ref --short HEAD ^/dev/null
end

function prompt_git
    set -l branch (__prompt_git_branch)
    if [ -z $branch ]
        return
    end

    echo '['$branch']'
end

function prompt_rbenv
    if not type -q 'rbenv'
        return
    end

    set -l rbenv_version (rbenv version-name)

    if type -q 'rbenv-gemset'
        set -l rbenv_gemset (rbenv gemset active ^/dev/null | sed 's| global||')
        if [ -n $rbenv_gemset ]
            set rbenv_version $rbenv_version'/'$rbenv_gemset
        end
    end

    echo '('$rbenv_version')'
end

function fish_prompt
    set_color brblack
    echo (prompt_pwd) (prompt_git) (prompt_rbenv)
    echo -n '$ '
    set_color normal
end
