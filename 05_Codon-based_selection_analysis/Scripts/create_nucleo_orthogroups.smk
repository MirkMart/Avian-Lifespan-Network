#snakemake file to create nucleotide orhogroups from amino acids ones

ORTHOGROUPS = glob_wildcards("/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/01_alignment/interesting_retro/{orthogroup}_aligned.fa")[0]

rule all:
	input:
		expand("04_nucleo_orthogroup/{orthogroup}.fna", orthogroup=ORTHOGROUPS)

rule ortho_nucleo:
	input:
		amino="/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/01_alignment/interesting_retro/{orthogroup}_aligned.fa"
	output:
		nucleo="04_nucleo_orthogroup/{orthogroup}.fna"
	shell:
		"bash create_nucleo_orthogroups_snake.sh {input.amino} {output.nucleo}"
