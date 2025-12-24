#!/usr/bin/env zsh

# Fabric-ai aliases with caching
alias fabric='fabric-ai'

_fabric_cache="$HOME/.cache/zsh/fabric_aliases.zsh"
_fabric_patterns_dir="$HOME/.config/fabric/patterns"

# Regenerate cache if patterns dir is newer than cache or cache doesn't exist
if [[ ! -f "$_fabric_cache" ]] || [[ "$_fabric_patterns_dir" -nt "$_fabric_cache" ]]; then
    mkdir -p "${_fabric_cache:h}"
    {
        for pattern_file in "$_fabric_patterns_dir"/*; do
            [[ -e "$pattern_file" ]] || continue
            pattern_name="$(basename "$pattern_file")"
            alias_name="${FABRIC_ALIAS_PREFIX:-}${pattern_name}"
            echo "alias $alias_name='fabric --pattern $pattern_name'"
        done
    } > "$_fabric_cache"
fi

[[ -f "$_fabric_cache" ]] && source "$_fabric_cache"

yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    fi

    transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
        transcript_flag="--transcript-with-timestamps"
        shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
}
