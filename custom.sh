#!/bin/bash
#Image-Magic is required to run this script
#Hugh Pearse DIT

#convert to PNG format to get alpha channel
convert  1.jpg png:2.png

#segment image from background
convert -transparent '#000000' -fuzz 10% 2.png 3.png

#automatically crop image
./autotrim.sh -c "0,0" 3.png 4.png

#remove color data
convert 4.png -brightness-contrast '-100x+100' 5.png

#extract geometry information
identify -unique 5.png | awk '{printf "Dimensions: WxH " $3"\n"}'
identify -verbose 5.png | sed '33,35!d'

#force to 512px width and height
convert 5.png -resize "512x512"! 6.png

#separate color channels RGB into greyscales sep-0.png to sep-2.png
convert 4.png -separate -channel RGB sep.png

#extract histogram information
echo -e "\nRed colorspace:"
identify -verbose sep-0.png | egrep "Colors:|deviation" | tr -s ' '
echo -e "\nGreen colorspace:"
identify -verbose sep-1.png | egrep "Colors:|deviation" | tr -s ' '
echo -e "\nBlue colorspace:"
identify -verbose sep-2.png | egrep "Colors:|deviation" | tr -s ' '
echo "";

##############################
#	Formulas
##############################

none=$(identify -verbose 5.png | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $1}')

black=$(identify -verbose 5.png | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $2}')

pixsum=$(echo "$none + $black" | bc)
ratio=$(echo "scale=2; $black / $pixsum" | bc)

echo Empty pixles is: $none
echo Black pixles: $black
echo Total pixles: $pixsum
echo Ratio of black to empty pixles is: $ratio:1
