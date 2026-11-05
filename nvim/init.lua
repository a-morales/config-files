vim.g.mapleader = " "
vim.g.maplocalleader = " "

_G.Config = {}
_G.gh = function(repo)
  return "https://github.com/" .. repo
end
local home = os.getenv("HOME")
_G.local_pack = function(path)
  return "file://" .. home .. "/" .. path
end
