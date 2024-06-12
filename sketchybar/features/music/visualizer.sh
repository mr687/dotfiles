#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	exit 1
fi

random_int() {
	local max=$1
	echo $(($RANDOM % $max + 1))
}

looping_random_int() {
	local max=$1
	local length=$2
	local base=$3
	local result=""

	for ((i = 0; i < $length; i++)); do
		r=$(bc -l <<<"($(random_int $max) - $max) / 2 + ($base / 100) * $max")
		result="$(printf "%.0f" $r) ${result}"
	done

	echo $result
}

append_command() {
	local result=""

	for size in "$@"; do
		result="${result} background.height=$size"
	done

	echo $result
}

animate() {
	local name=$1
	local length=$2
	local scale=$3
	local max_height=$(bc -l <<<"${length}*${scale}")
	local command="sketchybar --animate tanh 10 --set ${name}"
	local args="$(append_command $(looping_random_int 28 6 $max_height))"

	echo "${command} ${args}"
}

scale=$1

while [[ true ]]; do
	eval "$(animate "stick.1" 51 $scale)"
	eval "$(animate "stick.2" 60 $scale)"
	eval "$(animate "stick.3" 90 $scale)"
	eval "$(animate "stick.4" 100 $scale)"
	eval "$(animate "stick.5" 90 $scale)"
	eval "$(animate "stick.6" 60 $scale)"

	sleep 0.8
done
