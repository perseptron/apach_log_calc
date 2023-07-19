#!/bin/bash
#get Apache log file as a parameter
log_file=$1

#declare associative array where ip and bytes downloaded will be stored
declare -A  stat

#declare total bytes variable
total=0

#convert data size to human readable format
function to_hr() {
    local int_part=${1%.*}
    pow=${2:-0}
    if [[ ${#int_part} -gt 3 ]]; then
        pow=$(( pow+1 ))
        val=$(echo "scale=1; $1 / 1024" | bc)
        to_hr $val $pow
    else
        case "$pow" in
           0)
             echo "$1"B
             ;;
           1)
             echo "$1"KiB
             ;;
           2)
             echo "$1"MiB
             ;;
           3)
             echo "$1"GiB
             ;;
           4)
             echo "$1"TiB
             ;;
           5)
             echo "$1"PiB
             ;;
           6)
             echo "$1"EiB
             ;;
           *)
             echo "too much"
             ;;
        esac
    fi
}
#loop through lines and make calculations
while read -ra split_line; do
      #sqip empty lines
      if [[ ${#split_line} -eq 0 ]]; then
         continue
      fi
      ip=${split_line[0]}
      #skip wrong IP
      #TODO re
      if [[ ${#ip} -le 6 ]]; then
         continue
      fi
      traffic=${split_line[9]}
      if [[ ${traffic} == "-" ||  ${traffic} == " " ]]; then
         traffic=0
      fi
      #skip wrong size
      if ! [[ $traffic =~ ^[0-9]+$ ]] ; then
         echo "bad traffic size: $traffic"
         continue
      fi
      traff_inc=${stat[$ip]}
      stat[$ip]=$((traff_inc+traffic))
      total=$((total+traffic))
done <<< $( cat $log_file )
#output
echo "There are ${#stat[@]} unique ips"
totalhr=$(to_hr $total)
echo "Total downloaded: $total ($totalhr)"
for ip in "${!stat[@]}"; do
   printf '%-15s %9d\n' "$ip" "${stat[$ip]}"
done | sort -rn -k2 -k1
