#!/bin/bash

set +o histexpand

string="$1"

echo "string=$string"
numbers=0
chars=0
other=0

while [[ i -lt ${#string} ]] ; do
  letter=${string:$i:1}
  #echo $letter
  case "$letter" in
    [0-9])
       numbers=$((numbers+1))
       ;;
    [A-z])
       chars=$(($chars+1))
       ;;
    [!-\/])
       symb=$(($symb+1))
       ;;
    *)
       other=$(($other+1))
       ;;
  esac
  i=$(($i+1))
done
echo Numbers: $numbers Symbols: $symb Letters:$chars
