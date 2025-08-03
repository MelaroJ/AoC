#!/usr/bin/env bash

left=()
right=()

while read -r l r; do
  left+=("$l")
  right+=("$r")
done

mapfile -t leftsorted < <(printf '%d\n' "${left[@]}" | sort -n)
mapfile -t rightsorted < <(printf '%d\n' "${right[@]}" | sort -n)

len=${#left[@]}

p1=0
for ((i = 0; i < len; i++)); do
  x=${leftsorted[$i]}
  y=${rightsorted[$i]}

  diff=$((x - y))

  #abs
  dist=${diff#-}

  ((p1 += dist))
done

echo "$p1"

#freq right array
declare -A r_count
for value in "${right[@]}"; do
  ((r_count[$value]++))
done

p2=0
for value in "${left[@]}"; do
  freq=${r_count[$value]}
  prod=$((value * freq))
  ((p2 += prod))
done

echo "$p2"
