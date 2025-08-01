#!/usr/bin/env bash

set -euo pipefail

# Check args
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <year> <lang1> [lang2 ...]"
  exit 1
fi

YEAR=$1
shift
LANGUAGES=("$@")

if [[ -z "${AOC_SESSION:-}" ]]; then
  echo "AOC_SESSION not set"
  exit 1
fi

BASE_DIR="$HOME/aoc/$YEAR"

# Templates: maps lang -> extension and simple template
declare -A EXT_MAP=(
  [bash]="sh"
  [c]="c"
  [cpp]="cpp"
  [python]="py"
  [r]="R"
  [rust]="rs"
)

declare -A TEMPLATE_MAP=(
  [bash]=$'#!/usr/bin/env bash\n\ncat input'
  [c]=$'#include <stdio.h>\n\nint main(void) {\n    FILE *fp = fopen("input", "r");\n    return 0;\n}'
  [cpp]=$'#include <iostream>\n#include <fstream>\n\nint main() {\n    std::ifstream infile("input");\n    return 0;\n}'
  [python]=$'with open("input") as f:\n    data = f.read()'
  [r]=$'data <- readLines("input")\nprint(data)'
  [rust]=$'use std::fs;\n\nfn main() {\n    let input = fs::read_to_string("input").unwrap();\n    println!("{}", input);\n}'
)

for LANG in "${LANGUAGES[@]}"; do
  EXT="${EXT_MAP[$LANG]}"
  TEMPLATE="${TEMPLATE_MAP[$LANG]}"
  [[ -z "$EXT" || -z "$TEMPLATE" ]] && echo "No template defined for $LANG" && continue

  for DAY in $(seq -w 1 25); do
    DIR="$BASE_DIR/$LANG/day$DAY"
    mkdir -p "$DIR"

    INPUT_FILE="$DIR/input"
    [[ ! -s "$INPUT_FILE" ]] && {
      echo "Fetching input: $YEAR Day $DAY [$LANG]"
      curl -s --cookie "session=$AOC_SESSION" "https://adventofcode.com/$YEAR/day/$((10#$DAY))/input" -o "$INPUT_FILE"
      sleep 1
    }

    MAIN_FILE="$DIR/main.$EXT"
    [[ ! -f "$MAIN_FILE" ]] && echo -e "$TEMPLATE" >"$MAIN_FILE" && chmod +x "$MAIN_FILE"
  done
done
