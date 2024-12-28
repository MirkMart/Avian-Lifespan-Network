#!/bin/bash

#count % species after trimming orthofinder OGs

ntotspecies="$1"
conversion_ID_LID="$2"

IFS=$'\n'

#create output header 
#echo -e "OG\tlength\ttot\tLL\tSL\tNL\toutgroup" > species_perc_OG.txt #for trimmed OGs 
echo -e "OG\ttot\tLL\tSL\tNL\toutgroup" > species_perc_OG.txt #for OGs post Orthofinder

#create list of different species based on LID
grep "LL" "$2" > conv_LL
grep "SL" "$2" > conv_SL
grep "NL" "$2" > conv_NL

#count species grouped by LID
totLL=$(grep -c "LL" "$2")
totSL=$(grep -c "SL" "$2")
totNL=$(grep -c "NL" "$2")

for orthogroup in *.fa; do
        orthoname=$(basename -s _trimmed.fa "$orthogroup")
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
        percTOT=$(( $(wc -l orthospecies | cut -d" " -f1) * 100 / $1 ))
        #check if at least one outgroup is present. 
        if grep -qE "Stcam|Drnov|Cacas" "$orthogroup"; then 
                outgroup=Yes
        else
                outgroup=No
        fi
        echo -e "$orthoname\t$percTOT\t$percLL\t$percSL\t$percNL\t$outgroup" #for OGs post Orthofinder
        #length=$(head -n2 "$orthogroup" | tail -n1 | wc -m) #for trimmed OGs 
        #echo -e "$orthoname\t$length\t$percTOT\t$percLL\t$percSL\t$percNL\t$outgroup" #for trimmed OGs 
done >> species_perc_OG.txt

rm conv_LL conv_SL conv_NL orthospecies
