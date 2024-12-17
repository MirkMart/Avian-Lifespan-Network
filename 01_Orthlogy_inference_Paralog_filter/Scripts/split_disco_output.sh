#!/bin/bash

# Split the multiline output in multiple outputs
for disco in *_disco_tree.txt
	do
		OGname=$(basename -s _disco_tree.txt "$disco")
		split -d -a 2 --additional-suffix=_"$OGname".tre -l 1 "$disco" #(x00_OG0000000)
	done

# change the file name inverting OG definition and suffix
for tree in *.tre
	do
		name=$(basename -s .tre "$tree")
		new=$(echo "$name" | sed -E 's/(x[0-9]{2})_(OG[0-9]+$)/\2_\1/')
		mv "$tree" "$new".tre
	done

mkdir disco_single_tree
mkdir disco_single_OG

# recreate orthogroups using original ones
for tree in *.tre
	do
		name=$(basename -s .tre "$tree")
		OG=$(basename -s .tre "$tree" | sed -E 's/(OG[0-9]+)_([a-z][0-9]{2})/\1/')
		grep -o -E "[A-Z][a-z]{4}.[^:]+" "$tree" > sequences
		for sequence in $(cat sequences)
			do
				grep -A1 "$sequence" 01_OrthoFinder/Results_Nov21/Orthogroup_Sequences/LID50_TOT50_out/"$OG".fa >> disco_single_OG/"$name".fa
			done
	done
rm sequences

mv *.tre disco_single_tree
