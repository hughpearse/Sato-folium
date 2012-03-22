#!/bin/bash
#pass 4 parameters to this application
#filename genus species variety

if [ "$#" -eq "4" ];
then
	biometrics=`./customV2.sh $1`;
	#insert $2 $3 $4 $biometrics;
	mysql --user="root" --password="" mydb --execute="INSERT INTO leaf (genus,species,variety,whRatio,surfaceRatio,perimeterRatio,deviationR,deviationG,deviationB,meanR,meanG,meanB,maxR,maxG,maxB,gapRatio1,gapRatio3,gapRatio2,gapRatio4) VALUES (\"$2\", \"$3\", \"$4\", $biometrics);" -ss
	
else
	echo "Incorrect parameters!";
	echo "pass 4 parameters to this application:";
	echo "filename genus species variety";
fi

