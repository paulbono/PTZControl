#!/bin/bash //-x

function createImage(){
   text="$1"
   name="$2"
   color="$3"
   # Want an image of 288x288, border of 10x10 adds 20 to height and width
   magick convert -size "268x268" -background $color -fill black \
    -border "10x10" -bordercolor $color \
	-gravity Center caption:"$text" \
	-flatten "StreamDeckButtons/$name"
}

mkdir -p StreamDeckButtons

createImage "Main Worship Center" "MWC.png" "lightblue" &
createImage "Main Worship Center PNP" "MWCP.png" "lightblue" &
createImage "Main Pulpit Center" "MPC.png" "lightblue" &
createImage "Main Pulpit Center PNP" "MPCP.png" "lightblue" &
createImage "Main Sermon Center" "MSC.png" "lightblue" &
createImage "Main Sermon Center PNP" "MSCP.png" "lightblue" &
createImage "Main Altar Center" "MAC.png" "lightblue" &
createImage "Main Altar Center PNP" "MACP.png" "lightblue" &
createImage "Main Wide" "MW.png" "lightblue" &

createImage "Alt Worship Center" "AWC.png" "lightgreen" &
createImage "Alt Worship Center PNP" "AWCP.png" "lightgreen" &
createImage "Alt Pulpit Center" "APC.png" "lightgreen" &
createImage "Alt Pulpit Center PNP" "APCP.png" "lightgreen" &
createImage "Alt Sermon Center" "ASC.png" "lightgreen" &
createImage "Alt Sermon Center PNP" "ASCP.png" "lightgreen" &
createImage "Alt Altar Center" "AAC.png" "lightgreen" &
createImage "Alt Altar Center PNP" "AACP.png" "lightgreen" &
createImage "Alt Wide" "AW.png" "lightgreen"
