# This snakefile first aligns each chosen orthogroup, then trims it using the two-step process described in materials and methods.

configfile: "alignment_trimming.yaml"

ORTHOGROUPS = glob_wildcards("01_alignment/{orthogroup}_aligned.fa")[0]

#perform a first trimming process. file cannot be temporary beacuse they are needed for the retrotraslation

rule all:
    input:
        expand("05_trimmed_html/02_trimmed2/{orthogroup}_trimmed.html", orthogroup=ORTHOGROUPS)

rule BMGE_1:
    input:
        alignment="01_alignment/{orthogroup}_aligned.fa"
    output:
        fasta="05_trimmed_html/00_trimmed1_fasta/{orthogroup}_trimmed.fa",
	html="05_trimmed_html/01_trimmed1_html/{orthogroup}_trimmed.html"
    params:
        ent=config["trimming_params"]["entropy1"],
        gap=config["trimming_params"]["gaps1"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    shell:
        "java -jar /usr/local/BMGE-1.12/BMGE.jar -i {input.alignment} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -of {output.fasta} -oh {output.html}"

# perform a second trimming creating html output

rule BMGE_2:
    input:
        trimmed1="05_trimmed_html/00_trimmed1_fasta/{orthogroup}_trimmed.fa"
    output:
        "05_trimmed_html/02_trimmed2/{orthogroup}_trimmed.html"
    params:
        ent=config["trimming_params"]["entropy2"],
        gap=config["trimming_params"]["gaps2"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    shell:
        "java -jar /usr/local/BMGE-1.12/BMGE.jar -i {input.trimmed1} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -oh {output}"
