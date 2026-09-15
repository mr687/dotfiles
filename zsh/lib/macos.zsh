#!/usr/bin/env zsh

# macOS specific
#
# Check if running on macOS, otherwise stop here
[[ ! "x$SYSTEM" == "xDarwin" ]] && return

export GPG_TTY=$(tty)
export TERM="xterm-256color"
# [[ -n $TMUX ]] && export TERM="screen-256color"

export PATH="$HOME/bin:$PATH"

#
# GNU Core Utils
# brew info coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

[[ ! -f $DOTFILE_DIR/zsh/zshvault ]] || . $DOTFILE_DIR/zsh/zshvault

alias reload="source ${HOME}/.zshrc"

export EZA_CONFIG_DIR="${HOME}/.config/eza"

alias ls="eza --color=always --long --git --no-permissions --no-user"
alias ll="ls -a"
alias dev="cd ~/.dev"
alias home="cd ~"

alias builtincat="cat"
alias cat="bat"

alias builtinman="man"
alias man="tldr"

alias c="code ."
alias vim="nvim"
alias vi="nvim"

alias random32="openssl rand -base64 24 | tr -d '\n' ; echo"
alias flushdns="sudo killall -HUP mDNSResponder"
killport() {
  pid="$(lsof -ti tcp:$1)"
  kill -9 "${pid[@]}"
}

# TMUX aliases
ta() {
  tmux attach -t $1 || tmux new -s $1
}

alias tk='tmux kill-session -t'
alias tls='tmux ls'

tn() {
  tmux attach -t $1 || tmux new -s $1
}

alias mux=tmuxinator


export NODE_NO_WARNINGS=1

_evalcache /opt/homebrew/bin/brew shellenv
_evalcache starship init zsh

# FLUTTER SDK
# flutter_version=3_24_3
flutter_version=3_7_12
# flutter_version=3_35_7
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="$HOME/.dev/.flutter/$flutter_version/bin:$PATH"
export PATH="$HOME/.dev/.flutter/$flutter_version/bin/cache/dart-sdk:$PATH"
export PATH="$PATH:$HOME/.pub-cache/bin"
# alias fr="flutter run"
# alias fb="flutter pub run build_runner build --delete-conflicting-outputs"



# ANDROID SDK
export ANDROID_HOME="$HOME/.dev/.android-studio/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/build-tools/37.0.0:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"

# RUBY
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# PHP
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.2/include"

# GOLANG BREW
# export GOPATH="$HOME/go"
export PATH=$PATH:$(go env GOPATH)/bin

# PYTHON
export PATH="~/.pyenv/versions/3.6.15/bin:${PATH}"

# RUST
source "$HOME/.cargo/env"
export PATH="$(brew --prefix rustup)/bin:$PATH"

# COCOAPODS
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"

# METASPLOIT FRAMEWORK
export PATH="/opt/metasploit-framework/bin:$PATH"

# PODMAN CLI
export PATH="/opt/podman/bin:$PATH"
alias docker=podman

# BAT
export BAT_THEME="tokyonight_night"

# TheFuck
_evalcache thefuck --alias
_evalcache thefuck --alias fk

# Zoxide
_evalcache zoxide init --cmd cd zsh

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
