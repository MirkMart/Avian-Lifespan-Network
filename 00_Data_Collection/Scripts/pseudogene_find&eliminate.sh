#!/bin/bash/

# This part first transforms each proteome in its oneline form, then lists each plausible pseudogene present. 
# raw proteomes should have *.faa extension

for raw_proteome in *.faa; do
	awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' "$raw_proteome" > ${raw_proteome/.faa}".fa"
done

mkdir 00_raw_proteomes
mv *.faa 00_raw_proteomes/

for proteome in *.fa; do
	species=$(basename -s .fa "$proteome")
	grep -B1 '*' "$proteome" | grep ">" - >> "$species"_pseudogenes_name.txt
done

# This part wants to eliminate sequences that have been defined as pseudogenes genomes 

for pseudo_file in *_pseudogenes_name.txt; do
	species=$(basename -s _pseudogenes_name.txt "$pseudo_file")
	while IFS=$'\t' read -r header; do
		sed -E -i "/${header}/{N;d;}" "$species".fa # N option loads the next line found after the pattern and put it into pattern space too; d delete the pattern space
	done < "$pseudo_file" 
done 

mkdir 01_pseudogene_name
mv *_pseudogenes_name.txt 01_pseudogene_name/