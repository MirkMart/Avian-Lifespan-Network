# Codon-based selection analysis

## Retrotranslation

In order to explore if and which selections shaped sequences of interest, we retrotranslated our amino acid sequences into nucleotide ones. To do it we used the script written by Federico Plazzi. This script wrote aligned and trimmed nucleotide sequences taking into consideration which amino acid position was conserved (mask). The information about which amino acid is maintained and which is not was provided by an html file output of BMGE when using the '-oh' flag. Thus, we created a copy of the already used alignment_trimming snakemake file and altered it in order to rerun the trimming process this time with the changed format ([alignment_trimming_html.smk](./Scripts/alignment_trimming_html.smk)).

After the creation of the html files, we extracted the information we needed (maintained position) that formed the mask we used to retro-translate.

```Bash
for i in *.html; do name=$(basename -s _trimmed.html "$i"); grep "selected:" "$i" > "$name"_kept.html; done
```

This was only one of the three inputs we needed. The other two were aligned amino acids (not trimmed) and the orthogroups of nucleotide sequences (neither aligned nor trimmed). Very important is that sequence names need to match in order to use the script.

While aligned amino acids were already present and ready, the nucleotide orthogroups needed to be created. Once again, we extracted CDS using AGAT without translating them this time.

> **REALLY IMPORTANT**: the flag '-roo' (--remove_orf_offset) is indispensable in this very situation. Without it, proteins that present their first codon in a frame different from the first (in AGAT = 0) will be extracted erroneously. With the '-p' flag, AGAT automatically takes into consideration the protein phase, but this is not true when '-t CDS' is performed without translation.  

To compile orthogroups using nucleotide sequences but following the orthology already identified, we wrote [create_nucleo_orthogroups.sh](./Script/create_nucleo_orthogroups_snake.sh) used in a [snakemake](./Script/create_nucleo_orthogroups.smk) environment.

! IMPORTANT: -w is needed to match exactly the header we are interested into. Otherwise, both species|1452 and species|14523 will be added to "$ortho_out" creating a differnt orthogroup than the reference aligned one

Once all three inputs were ready, we elaborated Plazzi's script creating our snakemake version: [retrotranslation_snake.R](./Script/retrotranslation_snake.R). We then assembled it inside a snakefile [retrotranslation.smk](./Script/retrotranslation.smk). Before launching it, we installed the only library explicitly needed for it 'seqinr'.

```bash
snakemake -s retrotranslation.smk -j50
# in this case 12399 orthogroups were retrotranslated in more or less 1.5 huor. Actually, we only elaborated the orthogroups we were interested into, 1608 in total, namely those that were already highlighted as interesting by TRACCER. With -j25 it spend more or less 5 minutes to retrotranslated each one.
```

Several errors were outputted trying to make the script work. The first one was "Error in readLines(file): 'con' is not a connection". This one, typically, happens when 'read.fasta' has as an argument a NULL object. To fix it, we understood that this had to do with the fact that aligned sequences were not one-line, thus the function was not understanding the input file. Then "incomplete final line" popped out. This error is useful to suggest the possibility of an incomplete file when it does not end with a proper EOL. For this reason, we added a line and the end of each file. Then the first error came back, but this time for a typo.

A second round of position elimination was not necessary since the second round of BMGE trimming did not remove any, so the retrotranslation was done only with html files from the first trimming. This is because the second trimming process aimed to eliminate entire sequences that did not match the given thresholds. For this reason, we performed a last passage in order to recreate the ultimate orthogroups where headers from trimmed2 orthogroups were used to reconstruct our retrotranslated orthgroups using as sequence source the retrotranslated orthogroups. For this reason we wrote the script [definitive_orthogroups_snakemake.sh](./Scripts/definitive_orthogroups_snakemake.sh) run with the snakefile [definitive_orthogroups.smk](./Scripts/definitive_orthogroups.smk).

## Codeml

The analysis we ran was interested only in terminal branches. In this way, we were interested in knowing if something that happened in the past (probably seen using TRACCER) maintained an active selective force even in the present.

It was not possible to tag only terminal branches. For this reason, we performed a 2 vs 2 branch model test, where we confronted a model with 3 ω values (one for all the ancestors, one for interesting terminal branches, and one for background terminal branches) with a model with only 2 ω values (one for all the ancestors and one for all the terminal branch). In this way, we thought to decrease the importance of ancestors, since they where equally present as background noise in both analyses.

To do it, we used gene trees matching with codeml requirements: tips needed to present the identification number of the ω class to infere, defining wich branches shared the same one. The tagging taggin rule was:

- The default tag was 0 (all the ancestor).
- for gene trees needed to be investigated with 3 ω values, #1 identified interesting species and #2 background species.
- for gene trees needed to be investigated with 2 ω values, #1 identified all terminal branches.

Another change we did was to add at the beginning of each file a string reporting the number of species and the number of trees present in each file (needed for PAML suite).

```bash
#To add first line number of sequences and number of partitions for codeml analyses
for tree in 0[12]*/*/*.nwk; do num=$(grep -o -E "[A-Z][a-z]{4}" "$tree" | wc -l); sed -i -E "1s/^/"$num" 1\n/" "$tree"; done
```

A tree of example is (from tree OG0004687_x00.nwk):

```text
138 1
((Stcam #1,(Cacas #1,Drnov #2)),((((((((Drpub #2,Upepo #2),Costr #2),(((Bubub #1,Stocc #2),Atcun #2),Tyalb #1)),((((Haalb #1,Acgen #2),Hahar #2),Aqchr #1),Gycal #1)),(((Faper #2,(Fache #2,Farus #2)),(Fatin #2,Fanau #2)),((((Meund #2,(Amgui #1,Amaes #1)),(Eoros #1,Prate #1)),(Nenot #1,Sthab #1)),(Emtra #2,(Macya #2:1.481305,((((((Sieur #2,((Cebra #2,Cefam #2),(Pocae #2,Thlud #2))),((((Caust #2,Cafus #2),((Fialb #2,Oeoen #2),Errub #2)),Cimex #2),(Tored #2,(Lerot #2,Stvul #2)))),(Resat #2,Bogar #2)),(((Tagut #2,Lostr #2),Chgou #2),((Padom #2,Pamon #2),(Moalb #2,((((Sekir #2,((Qumex #2,Moate #2),Agpho #2)),Zoalb #2),(Phmel #2,(Cacar #1,Paamo #2))),(Secan #2,(Loleu #2,Locur #2))))))),(((Pamaj #2,Cycae #2),Poatr #2),(Hirus #2,(Aecau #2,(Pyjoc #2,(Lelut #2,(Pabia #2,(Cecet #2,((Sybor #2,Syatr #2),(Acaru #2,Hiict #2)))))))))),(Orori #2,(Stcin #2,(Lalud #2,((Cohaw #2,Cobra #2),Apcoe #2)))))))))),(Euhel #2,(Gaste #2,((Fugla #1,((Apfor #1,Appat #2),(Pypap #1,(Eumin #2,(Sphum #2,(Spdem #1,Spmag #1)))))),((((Pecri #1,Eggar #2),Ninip #2),(((Ananh #2,Phcar #1),Sudac #2),Frmag #1)),Cimag #2))))),(((Bareg #1,Grame #1),((((((Altor #1,Uraal #1),Cegry #1),Stpar #1),(Rynig #2,Ritri #1)),(Capug #2,Arint #2)),(Chvoc #2,Hihim #2))),(((Cucan #2,Gecal #2),(Canic #2,(Coliv #1,Pafas #2))),(((Chpel #2,Apapu #2),Caann #2),Ancar #2)))),Popod #2),((Oxjam #2,((Cyolo #1,Cyatr #2),(((Anpla #1,Anzon #2),Ayful #1),Aigal #2))),(((Cojap #2,((Phcol #2,(((Laleu #2,Lamut #2),(Typal #2,Ceuro #2)),Megal #2)),Gagal #1)),Numel #2),Allat #2)));
```

In order to speed all the analyses, we wrote a snakemake pipeline that managed all the passages needed to compute codeml analyses and the following likelihood ratio tests. In this [pipeline](./Scripts/codeml_aves.smk), likelihood ratio tests where performed using the 'scipi.maths' library in Python (choosen for its better adaptability with snakemake). That analysis, with the parsing of the results, where coded in the script [LRT_snake](./Scripts/LRT_snake.py).
