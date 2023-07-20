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
           0) echo "$1"B ;;
           1) echo "$1"KiB ;;
           2) echo "$1"MiB ;;
           3) echo "$1"GiB ;;
           4) echo "$1"TiB ;;
           5) echo "$1"PiB ;;
           6) echo "$1"EiB ;;
           *) echo "too much" ;;
        esac
    fi
}
