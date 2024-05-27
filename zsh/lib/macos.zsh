#!/usr/bin/env zsh

export GPG_TTY=$(tty)
export TERM="xterm-256color"
[[ -n $TMUX ]] && export TERM="screen-256color"

[[ ! -f $DOTFILE_DIR/zsh/zshvault ]] || . $DOTFILE_DIR/zsh/zshvault
[[ ! -f $DOTFILE_DIR/zsh/custom_function ]] || . $DOTFILE_DIR/zsh/custom_function

alias reload="source ${HOME}/.zshrc"

alias ls="eza --color=always --long --git --no-permissions --no-user"
alias ll="ls -a"
alias dev="cd ~/.dev"
alias home="cd ~"

alias builtincat="cat"
alias cat="bat"

alias builtinman="man"
alias man="tldr"

alias cd="z"

alias c="code ."
alias vim="nvim"

alias random32="openssl rand -base64 24 | tr -d '\n' ; echo"
alias flushdns="sudo killall -HUP mDNSResponder"
killport() {
  pid="$(lsof -ti tcp:$1)"
  kill -9 $pid
}

_evalcache /opt/homebrew/bin/brew shellenv
_evalcache starship init zsh

# FLUTTER SDK
flutter_version=3_22_0
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="$HOME/.dev/.flutter/$flutter_version/bin:$PATH"
export PATH="$PATH:$HOME/.pub-cache/bin"
alias fr="flutter run"
alias fb="flutter pub run build_runner build --delete-conflicting-outputs"

# ANDROID SDK
export ANDROID_HOME="$HOME/.dev/.android"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"

# RUBY
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# PHP
export PATH="$(brew --prefix php@8.1)/bin:$PATH"
export PATH="$(brew --prefix php@8.1)/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.1/include"

# GOLANG
export GO_VERSION="1.22.2";
export GOROOT="$HOME/.dev/.go/go$GO_VERSION"
export GOPATH="$HOME/.dev/.go/lib"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
alias goworkspaces="cd $GOPATH"

# RUST
source "$HOME/.cargo/env"

# COCOAPODS
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"

# export PATH="$HOME/.jenv/bin:$PATH"
# _evalcache jenv init -

_evalcache fzf --zsh

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source $DOTFILE_DIR/zsh/plugins/fzf-git/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# BAT
export BAT_THEME="tokyonight_night"

# TheFuck
_evalcache thefuck --alias
_evalcache thefuck --alias fk

# Zoxide
_evalcache zoxide init zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# conda deactivate
# <<< conda initialize <<<
