#!/bin/bash

metrics=`./customV2.sh $1`;

./query3.sh $metrics
