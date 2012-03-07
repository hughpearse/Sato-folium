#!/bin/bash

lfuzz="0.9"
ufuzz="1.1"

mysql --user="root" --password="" mydb --execute="
SELECT results.genus,results.species,COUNT(*) as occurrences 
from(
select genus,species from speciesAverage where whRatio BETWEEN ($1*$lfuzz) and ($1*$ufuzz)
union all select genus,species from speciesAverage where surfaceRatio BETWEEN ($2*$lfuzz) and ($2*$ufuzz)
union all select genus,species from speciesAverage where perimeterRatio BETWEEN ($3*$lfuzz) and ($3*$ufuzz)
union all select genus,species from speciesAverage where deviationR BETWEEN ($4*$lfuzz) and ($4*$ufuzz)
union all select genus,species from speciesAverage where deviationG BETWEEN ($5*$lfuzz) and ($5*$ufuzz)
union all select genus,species from speciesAverage where deviationB BETWEEN ($6*$lfuzz) and ($6*$ufuzz)
union all select genus,species from speciesAverage where meanR BETWEEN ($7*$lfuzz) and ($7*$ufuzz)
union all select genus,species from speciesAverage where meanG BETWEEN ($8*$lfuzz) and ($8*$ufuzz)
union all select genus,species from speciesAverage where meanB BETWEEN ($9*$lfuzz) and ($9*$ufuzz)
union all select genus,species from speciesAverage where maxR BETWEEN ($10*$lfuzz) and ($10*$ufuzz)
union all select genus,species from speciesAverage where maxG BETWEEN ($11*$lfuzz) and ($11*$ufuzz)
union all select genus,species from speciesAverage where maxB BETWEEN ($12*$lfuzz) and ($12*$ufuzz)
union all select genus,species from speciesAverage where gapRatio1 BETWEEN ($13*$lfuzz) and ($13*$ufuzz)
union all select genus,species from speciesAverage where gapRatio2 BETWEEN ($14*$lfuzz) and ($14*$ufuzz)
union all select genus,species from speciesAverage where gapRatio3 BETWEEN ($15*$lfuzz) and ($15*$ufuzz)
union all select genus,species from speciesAverage where gapRatio4 BETWEEN ($16*$lfuzz) and ($16*$ufuzz)
) results
group by genus,species ORDER BY occurrences DESC;
" -ss

