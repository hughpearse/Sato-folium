#!/bin/bash

metrics=`./customV2.sh $1`;

./query2.sh $metrics
