#!/bin/bash
#this script is to convert a leaf image into a tile
#and move it into the web folder
#Note: the results page does not support varities yes

if [ "$#" -eq "3" ];
then
	convert -define size=200x200 $1  -thumbnail 10000@ -gravity center -background skyblue -extent 100x100  $2-$3.${1/*\./}
	chmod 744 $2-$3.${1/*\./}
	sudo mv $2-$3.${1/*\./} /var/www/html/yii/myapplication/images/dbtiles/
else
	echo "Incorrect parameters!";
	echo "Enter: filename genus species";
fi

