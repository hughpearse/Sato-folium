#!/bin/bash

lfuzz="0.9"
ufuzz="1.1"

echo $* 1>&2

mysql --user="root" --password="" mydb --execute="
        #Crunch Algorithm
        select genus,species,
        (
            ( greatest(ABS($1),ABS(whRatio))            / least(ABS($1),ABS(whRatio)) ) + 
            ( greatest(ABS($2),ABS(surfaceRatio))               / least(ABS($2),ABS(surfaceRatio)) ) + 
            ( greatest(ABS($3),ABS(perimeterRatio))             / least(ABS($3),ABS(perimeterRatio)) ) + 
            ( greatest(ABS($4),ABS(deviationR))         / least(ABS($4),ABS(deviationR)) ) + 
            ( greatest(ABS($5),ABS(deviationG))         / least(ABS($5),ABS(deviationG)) ) + 
            ( greatest(ABS($6),ABS(deviationB))         / least(ABS($6),ABS(deviationB)) ) + 
            ( greatest(ABS($7),ABS(meanR))              / least(ABS($7),ABS(meanR)) ) + 
            ( greatest(ABS($8),ABS(meanG))              / least(ABS($8),ABS(meanG)) ) + 
            ( greatest(ABS($9),ABS(meanB))              / least(ABS($9),ABS(meanB)) ) + 
            ( greatest(ABS(${10}),ABS(maxR))            / least(ABS(${10}),ABS(maxR)) ) + 
            ( greatest(ABS(${11}),ABS(maxG))            / least(ABS(${11}),ABS(maxG)) ) + 
            ( greatest(ABS(${12}),ABS(maxB))            / least(ABS(${12}),ABS(maxB)) ) + 
            ( greatest(ABS(${13}),ABS(gapRatio1))               / least(ABS(${13}),ABS(gapRatio1)) ) + 
            ( greatest(ABS(${14}),ABS(gapRatio2))               / least(ABS(${14}),ABS(gapRatio2)) ) + 
            ( greatest(ABS(${15}),ABS(gapRatio3))               / least(ABS(${15}),ABS(gapRatio3)) ) + 
            ( greatest(ABS(${16}),ABS(gapRatio4))               / least(ABS(${16}),ABS(gapRatio4)) ) 
        )
        as difference
        from speciesAverage 
ORDER BY difference ASC;
" -ss
