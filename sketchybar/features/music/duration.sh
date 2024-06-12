#!/usr/bin/env bash

set -e

result=$1

duration_raw=$(nowplaying-cli get duration)
elapsed_time_raw=$(nowplaying-cli get elapsedTime)

if [[ $duration_raw != "null" || $elapsed_time_raw != "null" ]]; then
	duration=$(printf "%.0f" $duration_raw)
	elapsed_time=$(printf "%.0f" $elapsed_time_raw)

	if [ $result == "percentage" ]; then
		max_width=$2

		if [[ $duration != "null" && $elapsed_time != "null" ]]; then
			percentage=$(bc -l <<<"${elapsed_time}/${duration}*${max_width}")
			sketchybar --animate tanh 10 --set $NAME width=$percentage
		fi
	fi

	display_time() {
		local seconds=$1
		local format="%H:%M:%S"
		if [ "$seconds" -lt 3600 ]; then
			format="%M:%S"
		fi
		echo $(date -u -r $seconds +"${format}")
	}

	if [ $result == "elapsed_time" ]; then
		sketchybar --set $NAME label=$(display_time $elapsed_time)
	fi

	if [ $result == "duration" ]; then
		sketchybar --set $NAME label=$(display_time $duration)
	fi
fi
