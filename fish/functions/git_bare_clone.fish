function git_bare_clone -a dir_name repo_url -d "clone the github url repo as a bare repository"
    set -l GITHUB_URL $repo_url
    test -n "$GITHUB_URL"; or set GITHUB_URL (pbpaste)

    set -l REPO_NAME $dir_name
    test -n "$REPO_NAME"; or set REPO_NAME (basename -s .git $GITHUB_URL)

    mkdir $REPO_NAME; and cd $REPO_NAME; or return
    echo "created repo directory $REPO_NAME"

    git clone --bare $GITHUB_URL .bare
    echo "gitdir: ./.bare" > .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    set -l MAIN_BRANCH (git remote show origin | grep "HEAD branch" | awk -F': ' '{print $2}')

    git worktree add $MAIN_BRANCH $MAIN_BRANCH
end
