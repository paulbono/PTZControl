#!/bin/bash 
#-x

function createImage(){
   text="$1"
   name="$2"
   color="$3"
   # Want an image of 288x288, border of 10x10 adds 20 to height and width
   magick convert -size "268x268" -background $color -fill white \
    -border "10x10" -bordercolor $color \
	-gravity Center caption:"$text" \
	-flatten "StreamDeckButtons/$name"
}

mkdir -p StreamDeckButtons

createImage "Main Worship Center" "MWC.png" "blue" &
createImage "Main Worship Center PNP" "MWCP.png" "blue" &
createImage "Main Pulpit Center" "MPC.png" "blue" &
createImage "Main Pulpit Center PNP" "MPCP.png" "blue" &
createImage "Main Sermon Center" "MSC.png" "blue" &
createImage "Main Sermon Center PNP" "MSCP.png" "blue" &
createImage "Main Altar Center" "MAC.png" "blue" &
createImage "Main Altar Center PNP" "MACP.png" "blue" &
createImage "Main Wide" "MW.png" "blue" &
createImage "Main Baptism" "MB.png" "blue" &

createImage "Alt Worship Center" "AWC.png" "green" &
createImage "Alt Worship Center PNP" "AWCP.png" "green" &
createImage "Alt Pulpit Center" "APC.png" "green" &
createImage "Alt Pulpit Center PNP" "APCP.png" "green" &
createImage "Alt Sermon Center" "ASC.png" "green" &
createImage "Alt Sermon Center PNP" "ASCP.png" "green" &
createImage "Alt Altar Center" "AAC.png" "green" &
createImage "Alt Altar Center PNP" "AACP.png" "green" &
createImage "Alt Wide" "AW.png" "green"
