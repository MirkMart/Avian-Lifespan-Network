#!/bin/bash

#count species only in single gene orthogroups. it discards OGs with species present more than one time

nspecies="$1"
conversion_ID_LID="$2"

#create output header 
> perc_species_singlegeneOG.txt
echo -e "OG\ttot\tLL\tSL\tNL\toutgroup" > perc_species_singlegeneOG.txt

#create list of different species based on LID
grep "LL" "$2" > conv_LL
grep "SL" "$2" > conv_SL
grep "NL" "$2" > conv_NL

#count species grouped by LID
totLL=$(grep -c "LL" "$2")
totSL=$(grep -c "SL" "$2")
totNL=$(grep -c "NL" "$2")

for orthogroup in *.fa
	do
		n_species=$(grep ">" "$orthogroup" | wc -l)
		if (( "$n_species" <= "$nspecies" )) #number of total proteins in an orthogroup. If greater than nspecies then there are more proteins from one proteome
		then
			if (( $(grep ">" "$orthogroup" | sed -E 's/>([A-Z][a-z]{4})\|.+$/\1/' | sort | uniq -c | sort -nr | sed -E 's/^ *//g' | cut -d" " -f1 | head -n1) == 1 )) #if at least the first row, the higher, is 1 then every species is present once
			then
				orthoname=$(basename -s .fa "$orthogroup")
				grep ">" "$orthogroup" | sed -E 's/>([A-Z][a-z]{4})\|.+$/\1/' | sort -u > orthospecies
				nLL=0
				nSL=0
				nNL=0
				for LL in $(cat conv_LL | cut -f1)
						do 
								if grep -q "$LL" orthospecies
								then
										(( nLL++ ))
								fi
						done
				for SL in $(cat conv_SL | cut -f1)
						do 
								if grep -q "$SL" orthospecies
								then
										(( nSL++ ))  
								fi
						done
				for NL in $(cat conv_NL | cut -f1)
						do 
								if grep -q "$NL" orthospecies
								then
										(( nNL++ ))
								fi
						done
				percLL=$(( $nLL * 100 / $totLL ))
				percSL=$(( $nSL * 100 / $totSL ))
				percNL=$(( $nNL * 100 / $totNL ))
				percTOT=$(( $n_species * 100 / $nspecies ))
				if grep -qE "Almis|Alsin" "$orthogroup"; then #check if at least one outgroup is present
					outgroup=Yes
				else
					outgroup=No
				fi
				echo -e "$orthoname\t$percTOT\t$percLL\t$percSL\t$percNL\t$outgroup"
			fi
		fi
	done >> perc_species_singlegeneOG.txt

#all if clauses are nested in double round brakets in order to mean "arithmetic operation"

rm conv_LL conv_SL conv_NL orthospecies
