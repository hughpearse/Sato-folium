#!/bin/bash

metrics=`./customV2.sh $1`;

./query.sh $metrics | head
