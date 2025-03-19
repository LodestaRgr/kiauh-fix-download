#!/usr/bin/env bash

##
## Install KIAUH Download FIX
#
# sudo apt-get update && sudo apt-get install git -y
# cd ~ && git clone https://github.com/LodestaRgr/kiauh-fix-download.git
# chmod +x ./kiauh-fix-download/kiauh-fix-download.sh
# ./kiauh-fix-download/kiauh-fix-download.sh
#
## After fix, run Kiauh
#
# ./kiauh/kiauh.sh
#
# Enjoy...

set -e
clear -x

umask 022

KIAUH_FIX_SRCDIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
KIAUH_SRCDIR="${HOME}/kiauh"

#install KIAUH
sudo apt-get update && sudo apt-get install git -y
if (git clone "https://github.com/dw-0/kiauh.git" "${KIAUH_SRCDIR}"); then

#Run Fix
 cp "${KIAUH_FIX_SRCDIR}/git_clone_fix.sh" "${KIAUH_SRCDIR}/scripts/ui/git_clone_fix.sh"

 find "${KIAUH_SRCDIR}" -type f -name "*.sh" -exec sed -i -E \
  's|\bgit clone\b[[:space:]]+--[[:alnum:]_-]+||g' {} \;

 find "${KIAUH_SRCDIR}" -type f -name "*.sh" -exec sed -i -E \
  's|\bgit clone\b[[:space:]]+"([^"]+)"[[:space:]]+"([^"]+)"|git_clone "\1" "\2"|g' {} \;

 rm -rf "${KIAUH_FIX_SRCDIR}"
 
 echo "Fix complete !"
 echo "Run ./kiauh/kiauh.sh"
 
else
 echo "Error: No download Kiauh repository!!!"
fi
