#!/usr/bin/env zsh

[[ ! "x$SYSTEM" = "xLinux" ]] && return

if [[ -s '/etc/zsh_command_not_found' ]]; then
  source '/etc/zsh_command_not_found'
fi
