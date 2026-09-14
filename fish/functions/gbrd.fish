function gbrd -d "delete local branches via fzf (multi-select)"
    git for-each-ref --format="%(refname:short)" refs/heads | sort | uniq | fzf -m | xargs git branch -d
end
