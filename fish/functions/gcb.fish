function gcb -d "checkout a local branch via fzf"
    git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf | xargs git checkout
end
