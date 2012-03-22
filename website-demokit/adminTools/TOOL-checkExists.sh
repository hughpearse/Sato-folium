#!/bin/bash
#This script is to check if a species of genus currently exists in the database

echo "Checking if $@ exists...";

if [ "$#" -eq "1" ];
then
results=`mysql --user="root" --password="" mydb --execute="
SELECT COUNT(genus) from leaf where genus=\"$1\";
" -ss`
fi

if [ "$#" -eq "2" ];
then
results=`mysql --user="root" --password="" mydb --execute="
SELECT COUNT(*) from leaf where genus=\"$1\" and species=\"$2\";
" -ss`
fi

if [ "$results" -gt "0" ];
then
echo "$* currently exists, the database has no relationship constraints so work away.";
else
echo "$* does not currently exist in the database";
fi

