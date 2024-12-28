#/bin/bash

#snakemake version
#This script aims to create orthogroups using nucloetides sequences based on amino acids already inferred ones. 

ortho_amino=$1
ortho_out=$2

#extract the name of the orthogroup
name=$(basename -s .fa "$ortho_amino")
#create the list of headers
grep ">" "$ortho_amino" > "$name"_headers

for header in $(cat "$name"_headers); do
	#extract the species to search for the header directly in the correct genome saving time
	species=$(echo "$header" | cut -d'|' -f1 | cut -d'>' -f2)
	# -w is important to match exactly the header we are interested into. Otherwise, both species|1452 and species|14523 will be added to "$ortho_out" creating a differnt orthogroup than the reference aligned one
	grep -w -A1 "$header" <cds_nucle>/"$species".fna >> "$ortho_out"
	done

rm "$name"_headers
