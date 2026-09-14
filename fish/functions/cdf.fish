function cdf -a query -d "search for a file and cd to that directory"
    set --local file (_fzf_pick_file $query)
    if test -n "$file"
        cd (path dirname $file)
    end
end
