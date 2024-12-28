#this script performs retrotraslation using the script writte by Federico Plazzi. This is only an optimisation to parallelise it using snakemake

ORTHOGROUPS = glob_wildcards("/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/01_alignment/interesting_retro/{orthogroup}_aligned.fa")[0]

rule all:
	input:
                expand("05_retrotranslation/{orthogroup}_retro_masked.fna", orthogroup=ORTHOGROUPS)

rule retrotra:
	input:
		mask="/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/05_trimmed_html/01_trimmed1_html/{orthogroup}_kept.html",
		amino="/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/02_DISCO/02_disco_single_OG/01_alignment/interesting_retro/{orthogroup}_aligned.fa",
		nucle="/home/STUDENTI/mirko.martini/02_Longevity_in_aves/02_analysis/02_Orthology/04_nucleo_orthogroup/{orthogroup}.fna"
	output:
		retro="05_retrotranslation/{orthogroup}_retro.fna",
		retro_mask="05_retrotranslation/{orthogroup}_retro_masked.fna"
	script:
	        "retrotranslation_snake.R"
