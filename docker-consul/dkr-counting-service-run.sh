#!/usr/bin/env bash

docker run \
   --rm \
   -p 9001:9001 \
   -d \
   --name=weasel \
   hashicorp/counting-service:0.0.2
