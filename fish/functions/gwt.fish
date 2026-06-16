function gwt --description 'Switch to a git worktree via fzf'
  set -l dir (
    git worktree list | awk '$0 !~ /\(bare\)$/ {
      path = $1
      branch = $NF
      gsub(/[][]/, "", branch)
      printf "%s\t%s\n", branch, path
    }' | fzf --delimiter '\t' --with-nth 1 | awk -F '\t' '{print $2}'
  )
  test -n "$dir"; and cd $dir
end
