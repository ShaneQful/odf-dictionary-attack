#!/bin/bash
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