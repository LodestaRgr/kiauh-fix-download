# git clone fix downloader - git clone to download zip
function git_clone() {
 local repo=${1} branch=${2}

 echo "-- apply Download FIX by LodestaRgr --"

 branch_home=$(dirname "$branch")
 repo_name=$(echo "$repo" | sed -E 's|^https?://github.com/[^/]+/([^/]+).*|\1|')
 default_branch=$(git ls-remote --symref "${repo}" HEAD 2 \
                | grep '^ref: ' \
                | sed -E 's#^ref: refs/heads/([^[:space:]]+).*#\1#')
 wget -O "${branch}.zip" "${repo}/archive/refs/heads/${default_branch}.zip"
 unzip "${branch}.zip"
 rm "${branch}.zip"
 mv "${branch_home}/${repo_name}-${default_branch}" "${branch}"
}
