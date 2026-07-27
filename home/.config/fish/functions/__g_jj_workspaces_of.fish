function __g_jj_workspaces_of -a repo -d 'Emit non-default jj workspace roots of a repo'
    set --local roots
    command jj -R "$repo" workspace list \
        -T 'name ++ "\t" ++ self.root() ++ "\n"' 2>/dev/null | \
    while read --local line
        set --local parts (string split --max 1 \t -- $line)
        test (count $parts) -lt 2; and continue
        test "$parts[1]" = default; and continue
        set --append roots $parts[2]
    end
    test (count $roots) -gt 0; and printf '%s\n' $roots
end
