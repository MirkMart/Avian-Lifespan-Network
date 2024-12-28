#!/bin/bash/
set -e
set -u
set -o pipefail

touch tmp 
touch complete_busco_output.txt

for folder in */
	do
		cd "$folder"
		RESULTS=$(head -n8 short_summary.specific.*.txt | tail -n1)
		NAME=$(basename "$folder" | sed 's/_busco//')
		echo -e "$NAME\t$RESULTS" >> ../tmp
		cd ..
	done

sort -k2,2r tmp  > complete_busco_output.txt
rm tmp 
