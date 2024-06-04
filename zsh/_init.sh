#!/usr/bin/env zsh

#-----------------------------------------------------
# ensure to only execute on ZSH
# https://stackoverflow.com/a/9911082/339302
[ ! -n "$ZSH_VERSION" ] && return

# For MacOS
if [[ "x$SYSTEM" = "xDarwin"  ]]; then
    # system executables
    #export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/libexec
    # local system binaries
    # /etc/paths
    export PATH="/usr/local/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

    # /etc/paths.d/100-rvictl
    export PATH="/Library/Apple/usr/bin:$PATH"

    # /etc/paths.d/10-cryptex
    export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$PATH"
fi

#-----------------------------------------------------
# Load zinit
export ZI_HOME_DIR="${HOME}/.zi"
export ZI_BIN_DIR="${ZI_HOME_DIR}/bin"

# and the plugins
if [[ -f "${ZI_BIN_DIR}/zi.zsh" ]]; then
    source "${ZI_BIN_DIR}/zi.zsh"

    [[ -f "$ZSHCONFIG/zi-init.zsh" ]] && source "$ZSHCONFIG/zi-init.zsh"
else
    echo "The Zi init script does not exist at '${ZI_BIN_DIR}/zi.zsh'"
    exit 1
fi
#-----------------------------------------------------

#-----------------------------------------------------
# Setting autoloaded functions
#
my_zsh_fpath=${ZSHCONFIG}/autoloaded
brew_fpath="/opt/homebrew/share/zsh/site-functions"

fpath=($my_zsh_fpath $brew_fpath $fpath)

if [[ -d "$my_zsh_fpath" ]]; then
    for func in $my_zsh_fpath/*; do
        autoload -Uz ${func:t}
    done
fi
unset my_zsh_fpath
unset brew_fpath

#-----------------------------------------------------
#
# Load all scripts ${ZSHCONFIG}/lib/*.zsh
#
my_zsh_lib=${ZSHCONFIG}/lib
if [[ -d "$my_zsh_lib" ]]; then
   for file in $my_zsh_lib/*.zsh; do
      source $file
   done
fi
unset my_zsh_lib

#-----------------------------------------------------
# Development stuffs
#
# dev_config_init=${SCRIPTS}/dev-config/_init.sh
#
# [[ -f "$dev_config_init"  ]] && source "$dev_config_init"
#
# unset dev_config_init

#-----------------------------------------------------
# after all, set the PATH for macOS
[[ -x /bin/launchctl ]] && /bin/launchctl setenv PATH $PATH
