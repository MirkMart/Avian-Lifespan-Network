# This snakefile first aligns each chosen orthogroup, then trims it using the two-step process described in materials and methods.

configfile: "alignment_trimming.yaml"

ORTHOGROUPS = glob_wildcards("combined/{orthogroup}.fa")[0]

rule all:
    input:
        expand("trimmed/{orthogroup}_trimmed.fa", orthogroup=ORTHOGROUPS)

rule mafft:
    input:
        OG="combined/{orthogroup}.fa"
    output:
        "alignment/{orthogroup}_aligned.fa"   
    params:
        alg=config["alignment_params"]["algorithm"],
        typ=config["alignment_params"]["type"] 
    shell:
        "mafft --{params.alg} --{params.typ} {input.OG} > {output}"

rule BMGE_1:
    input:
        alignment="alignment/{orthogroup}_aligned.fa"
    output:
        temp("trimmed1/{orthogroup}_trimmed.fa")
    params:
        ent=config["trimming_params"]["entropy1"],
        gap=config["trimming_params"]["gaps1"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    shell:
        "java -jar /usr/local/BMGE-1.12/BMGE.jar -i {input.alignment} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -of {output}"

rule BMGE_2:
    input:
        trimmed1="trimmed1/{orthogroup}_trimmed.fa"
    output:
        "trimmed/{orthogroup}_trimmed.fa"
    params:
        ent=config["trimming_params"]["entropy2"],
        gap=config["trimming_params"]["gaps2"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    shell:
        "java -jar /usr/local/BMGE-1.12/BMGE.jar -i {input.trimmed1} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -of {output}"
  
