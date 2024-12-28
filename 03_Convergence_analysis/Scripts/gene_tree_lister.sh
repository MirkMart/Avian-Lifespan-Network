#!/bin/bash

#this script wants to list all gene tree used for the TRACCER analysis

for tree in *.raxml.bestTree; do 
	ORTHOGROUP=$(basename -s .raxml.bestTree "$tree")
	echo ">$ORTHOGROUP" >> gene_trees_kuhl.nwk
	cat "$tree" >> gene_trees_kuhl.nwk
done 
