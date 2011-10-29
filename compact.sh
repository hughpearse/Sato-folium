#!/bin/bash
convert $1 png:${1/\.*/.png}
echo "[${1/\.*/}]"
pic=${1/\.*/.png}
convert -transparent '#000000' -fuzz 10% $pic seg_$pic
./autotrim.sh -c "0,0" seg_$pic seg_cr_$pic
convert seg_cr_$pic -channel 'RGB' -black-threshold 96% -colorspace "Gray" seg_cr_sil_$pic
convert seg_cr_$pic -separate -channel RGB seg_cr_rgb_$pic
identify -verbose seg_cr_rgb_${pic/.png/}-0.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
identify -verbose seg_cr_rgb_${pic/.png/}-1.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
identify -verbose seg_cr_rgb_${pic/.png/}-2.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
none=`identify -verbose seg_cr_sil_$pic | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $1}'`
black=`identify -verbose seg_cr_sil_$pic | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $2}'`
pixsum=`echo "$none + $black" | bc`
ratio=`echo "scale=5; $black / $pixsum" | bc`
echo $ratio
