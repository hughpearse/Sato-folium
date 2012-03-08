#!/bin/bash

metrics=`./customV2.sh $1`;

./query4.sh $metrics | head
