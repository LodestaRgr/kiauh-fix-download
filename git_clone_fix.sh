git_clone() {
  local repo="$1"
  local branch="$2"

  echo "-- Apply KIAUH Fix Download -- by LodestaRgr --"

  # remove "git" at the end, if there is one
  repo="$(echo "$repo" | sed 's|\.git$||')"
  
  # We define the folder to a higher level
  local branch_home
  branch_home="$(dirname "$branch")"

  # Extracting the repository name (after github.com /...)
  local repo_name
  repo_name="$(echo "$repo" | sed -E 's|^https?://github.com/[^/]+/([^/]+).*|\1|')"

  # Defining the main branch (main, master or other)
  local default_branch
  default_branch="$(git ls-remote --symref "$repo" HEAD 2>/dev/null \
                  | grep '^ref: ' \
                  | sed -E 's#^ref: refs/heads/([^[:space:]]+).*#\1#')"

  # If the default_branch is undecided, we will return an error.
  if [[ -z "$default_branch" ]]; then
    echo "Couldn't identify the main branch of the repo: $repo"
    return 1
  fi

  # Downloading the archive, unzip
  wget -O "${branch}.zip" "${repo}/archive/refs/heads/${default_branch}.zip" || return 1
  unzip -o "${branch}.zip" -d "$branch_home" || return 1
  rm -f "${branch}.zip" || return 1

  # Rename the unpacked folder to the desired path
  # (usually, after unpacking, it turns out: <branch_home>/<repo_name>-<default_branch>)
  if ! mv -f "${branch_home}/${repo_name}-${default_branch}" "$branch"; then
    return 1
  fi
  
  return 0
}
