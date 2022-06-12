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

createImage "Cam 5 Worship Center" "MWC.png" "blue" &
createImage "Cam 5 Worship PNP" "MWCP.png" "blue" &
createImage "Cam 5 Pulpit Center" "MPC.png" "blue" &
createImage "Cam 5 Pulpit PNP" "MPCP.png" "blue" &
createImage "Cam 5 Sermon Center" "MSC.png" "blue" &
createImage "Cam 5 Sermon PNP" "MSCP.png" "blue" &
createImage "Cam 5 Altar Center" "MAC.png" "blue" &
createImage "Cam 5 Altar PNP" "MACP.png" "blue" &
createImage "Cam 5 Wide" "MW.png" "blue" &
createImage "Cam 5 Baptism" "MB.png" "blue" &

createImage "Cam 6 Worship Center" "AWC.png" "green" &
createImage "Cam 6 Worship PNP" "AWCP.png" "green" &
createImage "Cam 6 Pulpit Center" "APC.png" "green" &
createImage "Cam 6 Pulpit PNP" "APCP.png" "green" &
createImage "Cam 6 Sermon Center" "ASC.png" "green" &
createImage "Cam 6 Sermon PNP" "ASCP.png" "green" &
createImage "Cam 6 Altar Center" "AAC.png" "green" &
createImage "Cam 6 Altar PNP" "AACP.png" "green" &
createImage "Cam 6 Wide" "AW.png" "green"
