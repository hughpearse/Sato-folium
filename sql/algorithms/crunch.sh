#!/bin/bash

lfuzz="0.9"
ufuzz="1.1"

echo $* 1>&2

mysql --user="root" --password="" mydb --execute="
        #Crunch Algorithm
        select genus,species,
        (
                ABS(greatest ($1, whRatio)              / least ($1, whRatio)) +  
                ABS(greatest ($2, surfaceRatio)               / least ($2, surfaceRatio) ) +  
                ABS(greatest ($3, perimeterRatio)             / least ($3, perimeterRatio) ) +  
                ABS(greatest ($4, deviationR)         / least ($4, deviationR) ) +  
                ABS(greatest ($5, deviationG)         / least ($5, deviationG) ) +  
                ABS(greatest ($6, deviationB)         / least ($6, deviationB) ) +  
                ABS(greatest ($7, meanR)              / least ($7, meanR) ) +  
                ABS(greatest ($8, meanG)              / least ($8, meanG) ) +  
                ABS(greatest ($9, meanB)              / least ($9, meanB) ) +  
                ABS(greatest ($10, maxR)              / least ($10, maxR) ) +  
                ABS(greatest ($11, maxG)              / least ($11, maxG) ) +  
                ABS(greatest ($12, maxB)              / least ($12, maxB) ) +  
                ABS(greatest ($13, gapRatio1)         / least ($13, gapRatio1) ) +  
                ABS(greatest ($14, gapRatio2)         / least ($14, gapRatio2) ) +  
                ABS(greatest ($15, gapRatio3)         / least ($15, gapRatio3) ) +  
                ABS(greatest ($16, gapRatio4)         / least ($16, gapRatio4) )
        )
        as difference
        from speciesAverage 
ORDER BY difference ASC;
" -ss
