function git_bare_clone -a dir_name repo_url -d "clone the github url repo as a bare repository"
    set -l github_url $repo_url
    test -n "$github_url"; or set github_url (pbpaste)

    set -l repo_name $dir_name
    test -n "$repo_name"; or set repo_name (basename -s .git "$github_url")

    mkdir "$repo_name"; and cd "$repo_name"; or return
    echo "created repo directory $repo_name"

    git clone --bare "$github_url" .bare
    echo "gitdir: ./.bare" > .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    set -l main_branch (git remote show origin | grep "HEAD branch" | awk -F': ' '{print $2}')

    git worktree add "$main_branch" "$main_branch"
    git branch --set-upstream-to=origin/"$main_branch" "$main_branch"
    cd "$main_branch"
end
