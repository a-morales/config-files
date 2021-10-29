# fd() {
#   local dir
#   dir=$(find . -path '*/\.*' -prune -o -type d -print 2> /dev/null |  fzf-tmux +m -q "$1") && cd "$dir"
# }

cdf() {
   local file
   file=$(fzf-tmux +m -q "$1") && cd "$(dirname "$file")"
}

_fzf_compgen_path() {
  ag -p ~/.ignore --hidden --follow -g "$1"
}

vif() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

listAirplay() {
  dns-sd -B _airplay local
}

infoAirplay() {
  dns-sd -L $1 _airplay local
}

getAirplayIp() {
  dns-sd -G v4v6 "$1.local"
}

path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}
