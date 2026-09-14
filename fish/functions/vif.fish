function vif -a query -d "search for a file and open it in vim"
    set --local file (_fzf_pick_file $query)
    if test -n "$file"
        nvim $file
    end
end
