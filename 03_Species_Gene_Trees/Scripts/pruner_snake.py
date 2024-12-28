# This Python script is an adaptation from pruner.py specifically wrote to function inside snakemake pipeline 'gene_trees.smk'

from ete3 import Tree
import os
import re

#pruning
def pruning(tree_file, cladogram, out_directory):
    kuhl_cladogram=Tree(cladogram, format=1) #import cladogram in format 1 (flexible with internal node names)
    path_OG, iqtree = os.path.splitext(tree_file) #eliminate extension
    OG = os.path.basename(path_OG) 
    pruned_tree= OG + ".clado" #new name
    with open(tree_file, "r") as iqtree:
        content=iqtree.read()
        pattern=r"[A-Z][a-z]{4}"
        leaves=re.findall(pattern, content)
    kuhl_cladogram.prune(leaves)
    kuhl_cladogram.write(format=9,outfile=os.path.join(out_directory, pruned_tree)) #wirte the output in format 9 (leaf names)and create the path were to save it. 

pruning(snakemake.input[0], snakemake.input[1], snakemake.params[0])
