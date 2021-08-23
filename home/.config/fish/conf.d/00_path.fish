# fix PATH value
set --local path_tmp
for p in $PATH
    set path_tmp $path_tmp (string replace '~' $HOME $p)
end
set --export PATH $path_tmp

# local bin
set --export PATH $PATH $HOME/.local/bin
