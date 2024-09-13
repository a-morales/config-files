function vif -a query -d "search for a file and open it in vim"
    set --local file (fd --type f --color=always 2> /dev/null | fzf --query=$query --select-1 --exit-0 --ansi --preview='bat --style=numbers --color=always {}')
    if test -n "$file"
        nvim $file
    end
end
