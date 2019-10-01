#!/bin/bash


# Region
REGION='us-west-2'

# Packer image version
PACKERV='2.0'

# Directories
PACKERHOME='/Users/vlad/github.com/vsilverman/insight-devops'

packer build -machine-readable ${PACKERHOME}/packer-postgresql.json | tee ${PACKERHOME}/packer-postgresql.log
mv ${PACKERHOME}/*.log ${PACKERHOME}/logs

