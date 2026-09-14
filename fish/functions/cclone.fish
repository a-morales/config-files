function cclone -a dir_name -d "start claude in an sbx workspace using clone"
  set -l workspace $dir_name
  test -n "$workspace"; or set workspace "."
  sbx run --template claude-api-registry:latest --clone claude $workspace /Users/amorales/Code/disney
end
