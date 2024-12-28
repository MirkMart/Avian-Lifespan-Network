# This snakefile, for each trimmed aligned orthogroup sequence, performs ModelFinder using IQ-tree, then creates a cladogram using only present species and evaluates branch lengths with the inferred model on the cladogram using RAxML-NG

configfile: "gene_trees.yaml"

ORTHOGROUPS=glob_wildcards("trimmed/LT50o/{orthogroup, .+_x[0-9]{2}}_trimmed.fa")[0]

rule all:
    input:
        expand("gene_tree/Rax/{orthogroup}.raxml.bestTree", orthogroup=ORTHOGROUPS)

#sequence with only species name in the header
rule sequence_header:
    input:
        seq="trimmed/LT50o/{orthogroup}_trimmed.fa"
    output:
        temp("trimmed/LT50o/{orthogroup}.fa")
    shell:
        "sed -E 's/\|.+$//' {input.seq} > {output}"

#ModelFinder with only three models among with choose
rule IQ_tree:
    input:
        seq="trimmed/LT50o/{orthogroup}.fa"
    output:
        tree="gene_tree/IQ/{orthogroup}.treefile",
        log="gene_tree/IQ/{orthogroup}.log"
    params:
        mdl=config["IQ_tree"]["models"],
        alg=config["IQ_tree"]["algorithm"],
        pre="gene_tree/IQ/{orthogroup}"
    conda: "conda/tree.yaml"
    threads: 1
    shell:
        "iqtree -s {input.seq} -m {params.alg} -mset {params.mdl} -nt {threads} -pre {params.pre}"

#cladogram pruning with Ete3 prune function
rule prune_cladogram:
    input:
        tree="gene_tree/IQ/{orthogroup}.treefile",
        c_clado="gene_tree/complete_cladogram.nwk"
    output:
        "gene_tree/Rax/cladogram/{orthogroup}.clado"
    params:
        dir="gene_tree/Rax/cladogram"
    conda: "conda/python.yaml"
    script:
        "scripts/pruner_snake.py"

#branch length evaluation 
rule RAxML_NG:
    input:
        log="gene_tree/IQ/{orthogroup}.log",
        seq="trimmed/LT50o/{orthogroup}.fa",
        cld="gene_tree/Rax/cladogram/{orthogroup}.clado"
    output:
        "gene_tree/Rax/{orthogroup}.raxml.bestTree"
    params:
        out="gene_tree/Rax/{orthogroup}"
    conda: "conda/tree.yaml"
    threads: 1
    shell:
        """raxml-ng --msa {input.seq} --tree {input.cld} --model $(grep "Best-fit model" {input.log} | sed -E 's/(.+:) (.[^ ]+) (.+$)/\\2/') --prefix {params.out}  --threads {threads} --seed 3 --evaluate""" #double // are used to escape snakemake. without it would not read \2
