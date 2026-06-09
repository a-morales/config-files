#!/usr/bin/env bash
# Link the shared Claude skills directory into both the work and personal
# Claude config profiles. The canonical skills live in this dotfiles repo
# (~/.config/claude/skills); the profile config dirs are not version-controlled,
# so re-run this after setting up a new machine.
#
# Idempotent: safe to run repeatedly.
set -euo pipefail

SKILLS_DIR="${HOME}/.config/claude/skills"

# config dir -> profile name (for log output)
PROFILES=(
  "${HOME}/.claude"
  "${HOME}/.claude-personal"
)

mkdir -p "${SKILLS_DIR}"

for config_dir in "${PROFILES[@]}"; do
  link="${config_dir}/skills"

  # Already pointing at the right place? Nothing to do.
  if [[ -L "${link}" && "$(readlink "${link}")" == "${SKILLS_DIR}" ]]; then
    echo "ok:    ${link} -> ${SKILLS_DIR}"
    continue
  fi

  # A real (non-symlink) skills dir would be clobbered by ln -sf, so refuse.
  if [[ -e "${link}" && ! -L "${link}" ]]; then
    echo "skip:  ${link} exists and is not a symlink; leaving it alone" >&2
    continue
  fi

  mkdir -p "${config_dir}"
  ln -sf "${SKILLS_DIR}" "${link}"
  echo "link:  ${link} -> ${SKILLS_DIR}"
done
