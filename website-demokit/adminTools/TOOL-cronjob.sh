#!/bin/bash

mysql --user="root" --password="" mydb --execute="DELETE FROM varietyAverage;";
mysql --user="root" --password="" mydb --execute="DELETE FROM speciesAverage;";
mysql --user="root" --password="" mydb --execute="DELETE FROM genusAverage;";

mysql --user="root" --password="" mydb --execute="INSERT varietyAverage (variety,genus,species,whRatio,surfaceRatio,perimeterRatio,deviationR,deviationG,deviationB,meanR,meanG,meanB,maxR,maxG,maxB,gapRatio1,gapRatio3,gapRatio2,gapRatio4) SELECT variety,genus,species,avg(whRatio),avg(surfaceRatio),avg(perimeterRatio),avg(deviationR),avg(deviationG),avg(deviationB),avg(meanR),avg(meanG),avg(meanB),avg(maxR),avg(maxG),avg(maxB),avg(gapRatio1),avg(gapRatio3),avg(gapRatio2),avg(gapRatio4) from leaf group by genus,species,variety;"

mysql --user="root" --password="" mydb --execute="INSERT speciesAverage (genus,species,whRatio,surfaceRatio,perimeterRatio,deviationR,deviationG,deviationB,meanR,meanG,meanB,maxR,maxG,maxB,gapRatio1,gapRatio3,gapRatio2,gapRatio4) SELECT genus,species,avg(whRatio),avg(surfaceRatio),avg(perimeterRatio),avg(deviationR),avg(deviationG),avg(deviationB),avg(meanR),avg(meanG),avg(meanB),avg(maxR),avg(maxG),avg(maxB),avg(gapRatio1),avg(gapRatio3),avg(gapRatio2),avg(gapRatio4) from varietyAverage group by genus,species;"

mysql --user="root" --password="" mydb --execute="INSERT genusAverage (genus,whRatio,surfaceRatio,perimeterRatio,deviationR,deviationG,deviationB,meanR,meanG,meanB,maxR,maxG,maxB,gapRatio1,gapRatio3,gapRatio2,gapRatio4) SELECT genus,avg(whRatio),avg(surfaceRatio),avg(perimeterRatio),avg(deviationR),avg(deviationG),avg(deviationB),avg(meanR),avg(meanG),avg(meanB),avg(maxR),avg(maxG),avg(maxB),avg(gapRatio1),avg(gapRatio3),avg(gapRatio2),avg(gapRatio4) from varietyAverage group by genus;"
