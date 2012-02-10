#!/bin/bash
#Leaf Biometrics Script
#Author: Hugh Pearse

if [ "$#" == "0" ]
then
	echo "You need to pass an image as an argument"
	exit;
fi

#Basic environment tests
errors="0";
test -e ./autotrim.sh
errors=$(($? + $errors))
mogrify -version &> /dev/null 
errors=$(($? + $errors))

if [ "$errors" -gt "0" ]
then
	echo "Your environment is not set up properly.";
	echo "You may be missing some dependancies."
	echo "Check that all the necessary scripts are in the correct folder"
	exit;
fi
#----------File Conversion----------
	
	#Take a filename from the standard input
	#Shell expansion to replace the file extension with ".png"
	pic=${1/\.*/.png}
	
	#Convert file format to PNG
	convert $1 png:$pic
	
	#Segment leaf from uniform background color
	convert -transparent '#000000' -fuzz 10% $pic seg_$pic
	
	#Crop image border to leaf edges
	./autotrim.sh -c "0,0" seg_$pic seg_cr_$pic
	
	#Create segmented silhouette of leaf for measuring shape information
	convert seg_cr_$pic -channel 'RGB' -black-threshold 96% -colorspace "Gray" seg_cr_sil_$pic
	
	#Create black on white silhouette for measuring perimeter information
	convert seg_cr_sil_$pic -background "#FFFFFF" -alpha Background -alpha Off seg_cr_bwsil_$pic
	
	#Create image outline of leaf perimeter
	convert seg_cr_bwsil_$pic -edge 1 seg_cr_bwsil_edge_$pic
	
	#Cut the image up into 2 pixle slices
	width=`identify -format "%[width]" seg_cr_$pic`
	height=`identify -format "%[height]" seg_cr_$pic`
	oneThirdH=`echo "$height/3" | bc`
	oneThirdW=`echo "$height/3" | bc`
		
		#rotate image
		convert seg_cr_bwsil_$pic -rotate 180 seg_cr_bwsil_180_$pic
		convert seg_cr_bwsil_$pic -rotate 90 seg_cr_bwsil_90_$pic
		convert seg_cr_bwsil_$pic -rotate 270 seg_cr_bwsil_270_$pic
		
		#extract slices 1/3 from top
		convert -extract $widthx2+0+$oneThirdH seg_cr_bwsil_$pic slice1_$pic
		convert -extract $widthx2+0+$oneThirdH seg_cr_bwsil_180_$pic slice3_$pic
		convert -extract $heightx2+0+$oneThirdW seg_cr_bwsil_90_$pic slice2_$pic
		convert -extract $heightx2+0+$oneThirdW seg_cr_bwsil_270_$pic slice4_$pic
	
		convert -fill red slice1_$pic -floodfill +0+0 "#FFFFFF" -fuzz "10%" slice1.0_$pic
		convert -fill red slice3_$pic -floodfill +0+0 "#FFFFFF" -fuzz "10%" slice3.0_$pic
		convert -fill red slice2_$pic -floodfill +0+0 "#FFFFFF" -fuzz "10%" slice2.0_$pic
		convert -fill red slice4_$pic -floodfill +0+0 "#FFFFFF" -fuzz "10%" slice4.0_$pic

		convert +transparent red -fuzz 10% slice1.0_$pic slice1.1_$pic
		convert +transparent red -fuzz 10% slice3.0_$pic slice3.1_$pic
		convert +transparent red -fuzz 10% slice2.0_$pic slice2.1_$pic
		convert +transparent red -fuzz 10% slice4.0_$pic slice4.1_$pic

		convert slice1.1_$pic -bordercolor none -border 1x1 -trim +repage slice1.2_$pic
		convert slice3.1_$pic -bordercolor none -border 1x1 -trim +repage slice3.2_$pic
		convert slice2.1_$pic -bordercolor none -border 1x1 -trim +repage slice2.2_$pic
		convert slice4.1_$pic -bordercolor none -border 1x1 -trim +repage slice4.2_$pic

#----------Biometrics----------
	
	#Create Width to Height ratio

	#Extract information for Red, Green and blue color channel
	deviationR=`identify -channel R -format "%[standard-deviation]" seg_cr_$pic`
	deviationG=`identify -channel G -format "%[standard-deviation]" seg_cr_$pic`
	deviationB=`identify -channel B -format "%[standard-deviation]" seg_cr_$pic`

	meanR=`identify -channel R -format "%[mean]" seg_cr_$pic`
	meanG=`identify -channel G -format "%[mean]" seg_cr_$pic`
	meanB=`identify -channel B -format "%[mean]" seg_cr_$pic`

	maxR=`identify -channel R -format "%[max]" seg_cr_$pic`
	maxG=`identify -channel G -format "%[max]" seg_cr_$pic`
	maxB=`identify -channel B -format "%[max]" seg_cr_$pic`

	#Calculate relative surface area of the leaf
	#Take the total number of black pixles and empty
	#pixles to get the total surface area of the image.
	#Divide the black pixles by the total to get the ratio of leaf to image.
	width=`identify -format "%[width]" seg_cr_$pic`
	height=`identify -format "%[height]" seg_cr_$pic`
	totalPix=`echo "$width*$height" | bc`
	blackCount=`convert seg_cr_sil_$pic -format %c histogram:info:- 2>&1 | grep black | awk '{printf $1}' | tr -d ':'`
	noneCount=`convert seg_cr_sil_$pic -format %c histogram:info:- 2>&1 | grep none | awk '{printf $1}' | tr -d ':'`
	surfaceRatio=`echo "scale=5; $blackCount/$totalPix" | bc`

	#Calculate width to height ratio of the leaf
	whRatio=`echo "scale=2; $height/$width" | bc`

	#Calculate the leaf preimeter to surface area ratio
	#The edge should be 1px wide
	#we can count all of the white pixles to sum up the total perimeter
	#then divide the perimeter by the surface area
	whiteEdge=`convert seg_cr_bwsil_edge_$pic -format %c histogram:info:- 2>&1 | grep white | awk '{printf $1}' | tr -d ':'`
	perimeterRatio=`echo "scale=0; $blackCount/$whiteEdge" | bc`

	#Calculate gaps around the leaf as a ratio to the full slice
	sliceWidth1=`identify -format "%[width]" slice1.1_$pic`
	sliceWidth3=`identify -format "%[width]" slice3.1_$pic`
	sliceWidth2=`identify -format "%[width]" slice2.1_$pic`
	sliceWidth4=`identify -format "%[width]" slice4.1_$pic`

	gapWidth1=`identify -format "%[width]" slice1.2_$pic`
	gapWidth3=`identify -format "%[width]" slice3.2_$pic`
	gapWidth2=`identify -format "%[width]" slice2.2_$pic`
	gapWidth4=`identify -format "%[width]" slice4.2_$pic`

	gapRatio1=`echo "$sliceWidth1/$gapWidth1" | bc`
	gapRatio3=`echo "$sliceWidth3/$gapWidth3" | bc`
	gapRatio2=`echo "$sliceWidth2/$gapWidth2" | bc`
	gapRatio4=`echo "$sliceWidth4/$gapWidth4" | bc`

	#Separate genus and species name
	fullLatinName=${1/\.*/}
	genus=`echo "$fullLatinName" | tr '-' ' ' | awk '{printf $1}'`
	species=`echo "$fullLatinName" | tr '-' ' ' | awk '{printf $2}'`

#----------Output----------
	echo "$genus,$species,$whRatio,$surfaceRatio,$perimeterRatio,$deviationR,$deviationG,$deviationB,$meanR,$meanG,$meanB,$maxR,$maxG,$maxB,$gapRatio1,$gapRatio3,$gapRatio2,$gapRatio4";
