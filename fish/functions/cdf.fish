function cdf -a query -d "search for a file and cd to that directory"
    set --local file (fd --type f --hidden --color=always 2> /dev/null | fzf --query=$query --select-1 --exit-0 --ansi --preview='bat --style=numbers --color=always {}')
    if test -n "$file"
        cd (path dirname $file)
    end
end
