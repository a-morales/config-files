function _fzf_pick_file -a query -d "search files with fd+fzf and print the selected path"
    fd --type f --hidden --color=always 2> /dev/null | fzf --query=$query --select-1 --exit-0 --ansi --preview='bat --style=numbers --color=always {}'
end
