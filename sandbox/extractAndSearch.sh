#!/bin/bash

metrics=`./customV2.sh $1`;

./sqlSearch.sh $metrics | head
