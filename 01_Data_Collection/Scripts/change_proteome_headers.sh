#!/bin/bash/
set -e
set -u
set -o pipefail

tables_ID_AN_species=$1 #table that show the corrispondance between species ID and accession number used to download them

IFS=$'\n'
for proteome in *.fa; do
	ID=$(basename -s .fa "$proteome")
	AN=$(grep $ID "$1" | cut -d"_" -f1) # accession number
	if [ "$AN" == "GCF" ] #refseq genomes #spaces are essential in this type of command. without them a "command not found" error will occur
	then
		sed -E "s/(>rna-|>id-)(.[^ ]+)(.+$)/>"$ID"|\2/" "$proteome" > "$ID".faa #protein ID #here it is needed the use of double and not single quotes because only double ones allow variable expansion 
	elif [ "$AN" == "GCA" ] #genbank genomes
	then
		sed -E "s/(>.[^ ]+)(.[^ ]+-)(.[^ ]+)(.+$)/>"$ID"|\3/" "$proteome "> "$ID".faa #gene ID
	else #ensambl genomes
		sed -E "s/(>transcript:)(.[^ ]+)(.+$)/>"$ID"|\2/" "$proteome" > "$ID".faa #transcript ID and not gene one
	fi
done
