#snakemake file to create nucleotide orhogroups from amino acids ones

ORTHOGROUPS = glob_wildcards("/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/02_trimmed/LT50o/interesting_retro/{orthogroup}_trimmed.fa")[0]

rule all:
	input:
		expand("05_retrotranslation/00_trimmed2/{orthogroup}_retro_masked2.fna", orthogroup=ORTHOGROUPS)

rule ortho_nucleo:
	input:
		amino="/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/02_trimmed/LT50o/interesting_retro/{orthogroup}_trimmed.fa"
	output:
		nucleo="05_retrotranslation/00_trimmed2/{orthogroup}_retro_masked2.fna"
	shell:
		"bash nucleo_orthogroups_trimming2.sh {input.amino} {output.nucleo}"
