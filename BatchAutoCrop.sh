#!/bin/bash
sourced="./ManualCrop";
destd="./SegmentedAndAutocropped";

for i in `ls -1 $sourced`
do
	#create copy of $i and modify
	j=$i;
	j=${j/.jpg/.png}

	#convert to PNG format to get alpha channel
	convert  $sourced/$i png:$destd/1$j

	#segment image from background
	mogrify -transparent '#000000' -fuzz 10% $destd/1$j

	#automatically crop image
	./autotrim.sh -c "0,0" $destd/1$j $destd/$j

	#clean up
	rm $destd/1$j
done

