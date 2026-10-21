function __gg_collect_candidates -d 'Collect jj workspaces with the bookmarks and description of their parents'
    jj workspace list -T 'name ++ "\t" ++ coalesce(target.parents().map(|c| c.bookmarks().join(" ")).join(" "), "-") ++ "\t" ++ target.parents().map(|c| c.description().first_line()).join(" ") ++ "\n"' | column -t -s \t
end
