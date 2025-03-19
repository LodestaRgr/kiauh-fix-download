git_clone() {
  local repo="$1"
  local branch="$2"

  echo "-- Apply KIAUH Fix Download -- by LodestaRgr --"

  # Определяем папку на уровень выше
  local branch_home
  branch_home="$(dirname "$branch")"

  # Извлекаем имя репозитория (после github.com/...)
  local repo_name
  repo_name="$(echo "$repo" | sed -E 's|^https?://github.com/[^/]+/([^/]+).*|\1|')"

  # Определяем основную ветку (main, master или иная)
  local default_branch
  default_branch="$(git ls-remote --symref "$repo" HEAD 2>/dev/null \
                  | grep '^ref: ' \
                  | sed -E 's#^ref: refs/heads/([^[:space:]]+).*#\1#')"

  # Если вдруг default_branch не определился, вернём ошибку
  if [[ -z "$default_branch" ]]; then
    echo "Не удалось определить основную ветку у репо: $repo"
    return 1
  fi

  # Скачиваем архив
  wget -O "${branch}.zip" "${repo}/archive/refs/heads/${default_branch}.zip" || return 1

  # Распаковываем
  unzip -o "${branch}.zip" -d "$branch_home" || return 1

  # Удаляем архив
  rm -f "${branch}.zip" || return 1

  # Переименовываем распакованную папку в нужный путь
  # (обычно после распаковки получается: <branch_home>/<repo_name>-<default_branch>)
  if ! mv -f "${branch_home}/${repo_name}-${default_branch}" "$branch"; then
    return 1
  fi
  
  return 0
}
