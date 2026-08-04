#!/usr/bin/env zsh

# This script is executed when ghostty is opened.

# Ghostty launched from GUI gets a bare PATH; prepend Homebrew so sesh/fzf resolve.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

SESSION_NAME="scratch"

tmux new -A -s $SESSION_NAME
