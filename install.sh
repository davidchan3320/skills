#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
destination="${HOME:?HOME must be set}/.agents/skills"
selected=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dest DIRECTORY] [SKILL ...]

Install all bundled skills, or only the named skills.
Default destination: ~/.agents/skills

Options:
  --dest DIRECTORY  Install into a different skills directory.
  --list            List available skills and exit.
  -h, --help        Show this help and exit.

Run again to update installed files. Matching files are overwritten;
extra destination files are preserved. No downloads are performed.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

available=()
for source in "$repo_dir"/skills/*; do
  if [[ -d "$source" && -f "$source/SKILL.md" ]]; then
    available+=("${source##*/}")
  fi
done
[[ ${#available[@]} -gt 0 ]] || fail "No bundled skills found."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      [[ $# -ge 2 && -n "$2" && "$2" != -* ]] || fail "--dest requires a directory."
      destination=$2
      shift 2
      ;;
    --list)
      printf '%s\n' "${available[@]}"
      exit 0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*) fail "Unknown option: $1. Use --help for usage." ;;
    *) selected+=("$1"); shift ;;
  esac
done

if [[ ${#selected[@]} -eq 0 ]]; then
  selected=("${available[@]}")
fi

# Validate every name before installing any skill.
for skill in "${selected[@]}"; do
  found=false
  for name in "${available[@]}"; do
    if [[ "$skill" == "$name" ]]; then
      found=true
      break
    fi
  done
  [[ "$found" == true ]] || fail "Unknown skill: $skill. Use --list to see available skills."
done

mkdir -p -- "$destination"
destination=$(cd -- "$destination" && pwd -P)
case "$destination/" in
  "$repo_dir/skills/"*) fail "Choose a destination outside the repository's skills directory." ;;
esac

for skill in "${selected[@]}"; do
  target="$destination/$skill"
  [[ ! -L "$target" ]] || fail "Installed skill is a symlink: $target"
  [[ ! -e "$target" || -d "$target" ]] || fail "Destination is not a directory: $target"
done

for skill in "${selected[@]}"; do
  target="$destination/$skill"
  mkdir -p -- "$target"
  cp -R "$repo_dir/skills/$skill/." "$target/"
  printf 'Installed %s → %s\n' "$skill" "$target"
done

printf 'Start a new Codex session to use the installed skills.\n'
