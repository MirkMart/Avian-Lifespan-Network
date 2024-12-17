#!/bin/bash

best_scheme_nexus=$1

filename=$(basename -s _best_models.nex "$1")
sed -n '/mymodels/q;p'  "$1" | sed -E 's/^ *//g' | awk 'NR>2' > "$filename"_partition_conversion.nex #sed print the document from the top to the pattern. q stops the command at the pattern and p prints all the lines. second sed eliminates heading spaces and awk prints only lines after the header
awk '/mymodels/{p=1; next} p' "$1" | sed -E 's/^ *//g' | awk 'NR>1 {print last} {last=$0} END{if (NR>1) exit}' > "$filename"_mymodels.nex #awk after having found the pattern skip to the next line (p=1) and print it up to the end (next). sed eliminates heading spaces and awk cut the last line
while IFS=' ' read -r raw_model raw_partition; do
	model=$(sed 's/://' <<< "$raw_model")
	partition=$(sed 's/[,;]//' <<< "$raw_partition")
	number_partition=$(grep "$partition" "$filename"_partition_conversion.nex | cut -d"=" -f2 | sed -E 's/^ *//g' | sed 's/  /,/g' | sed 's/;//')
	echo -e "$model, $partition = $number_partition" >> "$filename"_best_models.rax
done < "$filename"_mymodels.nex  
