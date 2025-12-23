#!/usr/bin/env bash

# --- Color map: maps pixel value (0–19) to ANSI 24-bit color escape ---
declare -A colors
colors[0]='\033[38;2;242;54;36m'    # #f23624
colors[1]='\033[38;2;69;255;69m'    # #45ff45
colors[2]='\033[38;2;41;171;253m'   # #29abfd
colors[3]='\033[38;2;244;242;39m'  # #ffffff
colors[4]='\033[38;2;241;142;2m'        # #000000
colors[5]='\033[38;2;170;0;255m'    # #ffd500
colors[6]='\033[38;2;64;255;255m'    # #ff6a00
colors[7]='\033[38;2;255;255;255m'    # #b000ff
colors[8]='\033[38;2;46;46;46m'    # #ff00ff
colors[9]='\033[38;2;202;202;202m'  # #808080
colors[10]='\033[38;2;172;34;21m'   # #8b4513
colors[11]='\033[38;2;0;153;0m'   # #00ffff
colors[12]='\033[38;2;48;98;241m'     # #800000
colors[13]='\033[38;2;204;168;26m'     # #008000
colors[14]='\033[38;2;154;100;46m'     # #000080
colors[15]='\033[38;2;255;0;255m' # #ffc0cb
colors[16]='\033[38;2;0;224;153m'   # #ffff00
colors[17]='\033[38;2;133;133;133m'     # #0000ff
colors[18]='\033[38;2;255;153;255m'     # #00ff00
colors[19]='\033[38;2;243;215;170m' # #f3d7aa

reset='\033[0m'
width=128

# --- Function to render pixel array ---
render_pixels() {
  local pixels=("$@")
  for ((i=0; i<${#pixels[@]}; i++)); do
    c=${pixels[$i]}
    block=$(printf "\u2587")
    echo -ne "${colors[$c]}${block}${reset}"
    if (( (i + 1) % width == 0 )); then echo; fi
  done
}

# --- Get one full board message and close ---
get_board() {
  websocat --one-message --text 'wss://display.stamsite.nu/server' <<< \
  '{"type":"GetBoard","date":'$(date +%s000)',"data":{}}'
}

# --- Run ---
echo "Fetching board..."
json=$(get_board)
if [ -z "$json" ]; then
  echo "Error: Did not receive board data."
  exit 1
fi

# Extract pixel array
pixels=($(echo "$json" | jq -r '.data.board.pixels[]'))
clear
render_pixels "${pixels[@]}"

if [ -z "$json" ]; then
  echo "Error: Did not receive board data."
  exit 1
fi

# Extract pixel array
pixels=($(echo "$json" | jq -r '.data.board.pixels[]'))
clear
render_pixels "${pixels[@]}"
