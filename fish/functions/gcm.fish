function gcm -d "checkout the git-town main branch"
    git checkout (git town config | grep "main branch" | cut -d ":" -f 2 | tr -d " ")
end
