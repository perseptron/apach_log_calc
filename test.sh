#!/bin/bash
#get Apache log file as a parameter
DEFAULT_FILE=apache_logs1
log_file=${1:-$DEFAULT_FILE}

#declare associative array where ip and bytes downloaded will be stored
declare -A  stat

#declare total bytes variable
total=0

function to_hr() {
  local int_part="${1%.}"
  local iter="$2"
}


#loop through lines and make calculations
while read -r line; do
      split_line=($line)
      #sqip empty lines
      if [[ ${#split_line} -eq 0 ]]; then
	 continue
      fi
      ip=${split_line[0]}
      traffic=${split_line[9]}
      if [[ ${traffic} == "-" ||  ${traffic} == " " ]]; then
         traffic=0
      fi
      traff_inc=${stat[$ip]}
      stat[$ip]=$((traff_inc+traffic))
      total=$((total+traffic))
done <<< $( cat $log_file )

echo "There are ${#stat[@]} unique ips"
echo "Total downloaded: $total ($(($total/1024/1024))MiB)"
for ip in "${!stat[@]}"; do
   printf '%-15s %9d\n' "$ip" "${stat[$ip]}"
done | sort -rn -k2 -k1

