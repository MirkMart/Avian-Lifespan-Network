#/bin/bash

#snakemake version
#This script aims to create orthogroups using nucloetides sequences based on amino acids already inferred ones. 

ortho_amino=$1
ortho_out=$2

name=$(basename -s _trimmed.fa "$ortho_amino")
grep ">" "$ortho_amino" > "$name"_headers
for header in $(cat "$name"_headers); do
	grep -w -A1 "$header" /home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/05_retrotranslation/"$name"_retro_masked.fna >> "$ortho_out"
	done

rm "$name"_headers

