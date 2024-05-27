#!/usr/bin/env zsh

ZSHCONFIG=${DOTFILE_DIR}/zsh

ZI_HOME_DIR="${HOME}/.zi"
ZI_BIN_DIR="${ZI_HOME_DIR}/bin"

echo "Cloning zi repository"

mkdir -p "${ZI_HOME_DIR}"

git clone https://github.com/z-shell/zi.git "${ZI_BIN_DIR}"

echo "Link ZSH resource files to '${HOME}'"

echo "Done!"
