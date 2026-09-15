#-----------------------------------------------------
# Set VIM mode
# e.g. https://dougblack.io/words/zsh-vi-mode.html
# Key code table: https://www.zsh.org/mla/users/2014/msg00266.html
#
# vim mode keybindings
bindkey -v

bindkey '^P' up-history                           # ctrl-p
bindkey '^N' down-history                         # ctrl-n
bindkey -M viins '^p' up-line-or-history
bindkey -M viins '^n' down-line-or-history

bindkey "^E" end-of-line                          # ctrl-e
bindkey "^F" forward-word                         # ctrl-f
bindkey "^B" backward-word                        # ctrl-b
