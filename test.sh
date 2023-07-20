#!/bin/bash
#get Apache log file as a parameter
log_file=$1

# use human readable byte converter
source ./b_conv.sh

#declare associative array where ip and bytes downloaded will be stored
declare -A  stat

#declare total bytes variable
total=0

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
