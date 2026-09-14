function gcr -d "checkout a remote branch via fzf"
    git for-each-ref --format="%(refname:short)" refs/remotes | sort | uniq | fzf | xargs git checkout -t
end
