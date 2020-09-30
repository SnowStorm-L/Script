#!/usr/bin/env bash 
HASH1=${1}
DATE="$(date "+%m_%d_%Y_%H%M")"
FILENAME="deploy-$DATE.zip" # Change this to wherever you want to save the file
git archive -o $FILENAME $HASH1
