#!/bin/bash

# Copyright (c) 2012 Shane Quigley
# 
# This software is MIT licensed see link for details
# http://www.opensource.org/licenses/MIT

TS=$(date +%s)
while read line ;do
	OUTPUT=`wvWare -p $line $1`
	if [ -n "$OUTPUT" ]; then
		echo $line
		break
	fi
done < password
let "out = $(date +%s)-$TS"
echo "$out"