#!/bin/bash

function to_hr() {
    local int_part=${1%.*}
    pow=${2:-0}
    if [[ ${#int_part} -gt 3 ]]; then
	pow=$(( pow+1 ))
	val=$(printf "%.1f" $(echo "scale=10; $1 / 1024" | bc))
	to_hr $val $pow
    else
	case "$pow" in
	   0)
	     echo $1B
	     ;;
	   1)
	     echo $1KiB
	     ;;
	   2)
	     echo $1MiB
	     ;;
	   3)
	     echo $1Gib
	     ;;
	   4)
	     echo $1TiB
	     ;;
	   *)
	     echo "too much"
	     ;;
	esac
    fi
}

to_hr $1
