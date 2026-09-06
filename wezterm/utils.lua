--- @type Wezterm
local wezterm = require("wezterm")
local M = {}

M.process_icons = {
  nvim = wezterm.nerdfonts.custom_neovim,
  vim = wezterm.nerdfonts.custom_neovim,
  vif = wezterm.nerdfonts.custom_neovim,
  mdterm = wezterm.nerdfonts.oct_markdown,
  fish = wezterm.nerdfonts.md_fish,
  zsh = wezterm.nerdfonts.dev_terminal,
  bash = wezterm.nerdfonts.cod_terminal_bash,
  git = wezterm.nerdfonts.dev_git,
  hunk = wezterm.nerdfonts.cod_git_pull_request_create,
  gh = wezterm.nerdfonts.oct_mark_github,
  lazygit = wezterm.nerdfonts.dev_git,
  lazyworktree = wezterm.nerdfonts.md_family_tree,
  deno = wezterm.nerdfonts.dev_denojs,
  node = wezterm.nerdfonts.md_nodejs,
  bun = wezterm.nerdfonts.dev_bun,
  python = wezterm.nerdfonts.dev_python,
  python3 = wezterm.nerdfonts.dev_python,
  ruby = wezterm.nerdfonts.dev_ruby,
  go = wezterm.nerdfonts.md_language_go,
  cargo = wezterm.nerdfonts.dev_rust,
  rustc = wezterm.nerdfonts.dev_rust,
  docker = wezterm.nerdfonts.dev_docker,
  ssh = wezterm.nerdfonts.md_ssh,
  make = wezterm.nerdfonts.seti_makefile,
  btop = wezterm.nerdfonts.md_chart_areaspline,
  herdr = wezterm.nerdfonts.md_sheep,
  claude = wezterm.nerdfonts.fa_robot,
  pi = wezterm.nerdfonts.fa_robot,
  omp = wezterm.nerdfonts.fa_robot,
  sbt = wezterm.nerdfonts.dev_scala,
  mill = wezterm.nerdfonts.dev_scala,
  caffeinate = wezterm.nerdfonts.md_coffee,
  leaf = wezterm.nerdfonts.fa_leaf
}

local ignore_processes_for_unseen = {
  vim = true,
  nvim = true,
  vif = true
}

function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

function M.get_cwd_path(cwd_uri)
  if not cwd_uri then
    return ""
  end
  if type(cwd_uri) == "userdata" then
    return cwd_uri.file_path or ""
  end
  return tostring(cwd_uri)
end

function M.get_process_icon(title, proc_name, default_icon)
  local title_cmd = title and title:match("^(%S+)")
  return (title_cmd and M.process_icons[title_cmd:lower()]) or M.process_icons[proc_name:lower()] or default_icon
end

function M.get_updated_title_and_icon(title, proc_name, default_icon)
  local title_cmd = title and title:match("^(%S+)")
  local icon = title_cmd and M.process_icons[title_cmd:lower()]
  if (icon ~= nil) then
    local updated_title = title:match("^%S+%s*(.+)")
    return icon, updated_title
  else
    icon = M.process_icons[proc_name:lower()] or default_icon
    return icon, title
  end
end

local function ignore_process_for_unseen_output(pane)
  local proc = M.basename(pane.foreground_process_name or "")

  return ignore_processes_for_unseen[proc] or false
end

function M.tab_has_unseen_output(tab, panes)
  local pane_list = tab.panes or panes or {}
  for _, p in ipairs(pane_list) do
    if p.has_unseen_output and p.progress == 'None' and not ignore_process_for_unseen_output(p) then
      return true
    end
  end

  return false
end

-- Walk up from cwd looking for a .git directory or file. Handles:
--   1. Regular repo:   <root>/.git/ (directory)
--   2. Worktree/submodule: <dir>/.git (file containing "gitdir: <path>")
-- Returns absolute path to the git dir, or nil if not inside a repo.
function M.find_git_dir(cwd)
  if not cwd or cwd == "" then return nil end
  local path = cwd
  while path and path ~= "" and path ~= "/" do
    -- Case 1: .git is a directory with a HEAD file
    local head = io.open(path .. "/.git/HEAD", "r")
    if head then
      head:close()
      return path .. "/.git"
    end

    -- Case 2: .git is a file pointing to a gitdir
    local gitfile = io.open(path .. "/.git", "r")
    if gitfile then
      local first = gitfile:read("*l") or ""
      gitfile:close()
      local gitdir = first:match("^gitdir:%s*(.+)$")
      if gitdir then
        if not gitdir:match("^/") then
          gitdir = path .. "/" .. gitdir
        end
        return gitdir
      end
    end

    -- Walk up one level
    local parent = path:match("^(.+)/[^/]+$")
    if not parent or parent == path then break end
    path = parent
  end
  return nil
end

function M.find_git_config(cwd)
  local gitdir = M.find_git_dir(cwd)
  if not gitdir then return nil end

  local commondir = io.open(gitdir .. "/commondir", "r")
  if commondir then
    local resolve = commondir:read("*l")
    commondir:close()
    if resolve then
      gitdir = gitdir .. "/" .. resolve
    end
  end

  local config = io.open(gitdir .. "/config", "r")
  if config then
    local content = config:read("*all")
    config:close()
    return content
  end

  return nil
end

function M.get_git_name(cwd)
  local config = M.find_git_config(cwd)
  if config then
    local remote = config:match("%s+url%s+=%s+(%S+)")
    if remote and #remote > 0 then
      return string.gsub(remote, "(.*[/\\])(.*).git", "%2")
    end
  end
  return nil
end

-- Read current branch from .git/HEAD directly (no subprocess).
-- Handles: symbolic ref (normal branch), detached HEAD (short hash).
-- ~10-20μs per call; replaces the ~20ms `git branch --show-current` fork.
function M.read_git_branch(cwd)
  local gitdir = M.find_git_dir(cwd)
  if not gitdir then return "" end
  local f = io.open(gitdir .. "/HEAD", "r")
  if not f then return "" end
  local line = f:read("*l")
  f:close()
  if not line then return "" end

  -- Common case: symbolic ref on a local branch
  local branch = line:match("^ref: refs/heads/(.+)$")
  if branch then return branch end

  -- Rebase in progress: show the branch being rebased (matches user expectation)
  local rebase = io.open(gitdir .. "/rebase-merge/head-name", "r")
      or io.open(gitdir .. "/rebase-apply/head-name", "r")
  if rebase then
    local rb = rebase:read("*l") or ""
    rebase:close()
    local rb_branch = rb:match("refs/heads/(.+)$")
    if rb_branch then return rb_branch end
  end

  -- Non-heads ref (refs/tags/*, refs/remotes/*, etc.) or detached HEAD.
  -- Return "" to hide the branch section, matching `git branch --show-current`.
  return ""
end

return M
