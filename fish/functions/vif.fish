function vif -a query -d "search for a file and open it in vim"
    set --local file (fzf --query=$query --select-1 --exit-0)
    if test -n "$file"
        nvim $file
    end
end
