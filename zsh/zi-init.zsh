#!/usr/bin/env zsh

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi ice wait"0" atload"_zsh_autosuggest_start" lucid
zi light zsh-users/zsh-autosuggestions

zi ice wait"0" lucid
zi light zsh-users/zsh-completions

zi ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
zi light zdharma-continuum/fast-syntax-highlighting

zi from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
    direnv/direnv

zi light zsh-users/zsh-history-substring-search

zi ice wait"0" lucid
zi load htr3n/history-search-multi-word

export NVM_COMPLETION=true
zi ice wait"0" lucid
zi light lukechilds/zsh-nvm

zi ice as"completion" lucid
zi snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zi ice as"completion" lucid
zi snippet https://github.com/Amar1729/yabai-zsh-completions/blob/main/src/_yabai

zi snippet https://github.com/mroth/evalcache/blob/master/evalcache.plugin.zsh
