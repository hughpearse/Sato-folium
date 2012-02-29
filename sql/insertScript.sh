#!/bin/bash

for line in `cat databaseForInserts.txt`
do
mysql --user="root" --password="" mydb --execute="INSERT INTO leaf (variety,genus,species,whRatio,surfaceRatio,perimeterRatio,deviationR,deviationG,deviationB,meanR,meanG,meanB,maxR,maxG,maxB,gapRatio1,gapRatio3,gapRatio2,gapRatio4) VALUES ('wild',$line);"
done
