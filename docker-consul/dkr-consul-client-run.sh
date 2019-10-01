#!/usr/bin/env bash

docker run \
    --rm \
    --name=fox \
    consul agent -node=client-1 -join=172.17.0.2


