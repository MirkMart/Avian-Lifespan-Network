# Species and Gene Trees

## Species tree

### Complete cladogram

Many of our analyses required a known species tree in order to make their runs easier due to sister relationship knowledge. This, brought us to create a cladogram that showed the current state of the art about avian phylogeny.

For this reason, we deeply used [Avitaxonomicon](https://www.bird-phylogeny.de/) information and other sources:

- [Estrilidae](https://en.wikipedia.org/wiki/Estrildidae).
- [Falco](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-018-4615-z).
- [Sylvioidea](https://doi.org/10.1016/j.ympev.2005.05.015).
- [Corvidae](https://en.wikipedia.org/wiki/Corvidae).
- [Corvus](https://doi.org/10.3109/19401736.2015.1043540).
- [Cardinalidae](https://en.wikipedia.org/wiki/Cardinalidae).
- [Icteridae](https://doi.org/10.1016/j.ympev.2013.11.009).

At the end, we manually wrote the tree creating monophyletic groups and adding them progressively, obtaining an almost resolved tree. While the relationship between the genre _Cinclus sp_ and the two families Muscicapidae e Turdidae was not completely sure, it presented always a concordant relationship among the sources we used using species we had. DIfferently, the relationship between the two superfamilies of Muscicapoidea and Certhioidea, and two the genres _Regulus sp._ and _Bombycilla sp._ presented difficulties since it was resolved in two different ways by the groups of the two experts Dr. [Kuhl](https://doi.org/10.1093/molbev/msaa191) and Dr. [Oliveros](https://www.pnas.org/doi/epdf/10.1073/pnas.1813206116). For this reason, we wrote their relationship as a [polytomy](./Files/aves_cladogram_politomy.nwk), in order to let IQ-Tree resolve it using the information we were giving to it.

### Species tree inference

Species tree inference was performed using both [IQ-Tree](http://www.iqtree.org/) and [RAxML-NG](https://github.com/amkozlov/raxml-ng)

### Single-gene orthogroups

We want to use our complete single orthogroups to infer species tree branch lengths. The aim was to use at least 500 genes, in order to obtain a reliable branch length value. Since the best set of orthologs was not big enough, we extracted all single-copy orthogroups that did not present every species (so they were not complete) to increase the number of orthogroups 1:1. This is important when complete single-copy orthogroups are not numerous enough, so we tried different percentages of total completeness of single-copy orthogroups (75,90,95,99). To extract noncomplete single-gene OGs we ran [count_singlegeneOG_perc_species](Scripts/count_singlegeneOG_perc_species.sh), which worked only on orthogroups that presented no more than one sequence for each species.

Very surprisingly, single not complete OGs with at least from 75% to 95% of species counted more than 1000 OGs. For this reason, in the end, we chose 99% of completeness as the threshold. This returned more than 350 OGs, but we lowered it to 265 forcing them to contain all LLLQ and SLLQ species, so only NL species were lost. We then accumulated 578 OGs between the complete ones and those that reached 99% of completeness (265 + 313 -> 578). With these new OGs, we inferred the species tree.

## Alignment and trimming

Alignment was performed using [MAFFT](https://mafft.cbrc.jp/alignment/software/) (v7.490) while trimming using [BMGE](https://gitlab.pasteur.fr/GIPhy/BMGE) (1.12). We decided to apply a two-step trimming using the parameters: '-h 0.5' and '-g 0.4' for the first trimming, and '-h 1' and '-g 0.8:1' for the second (in the version ≥ 2 of BMGE `-h` is now `-e` and this two-step approach is no longer permitted since the parametr `-g` is restricted to vertical gap position and is no longer usable specifying both horizontal and vertical gap positions, as in the second step). To perform this passage as rapidly as possible, we decided to start relying on a process manager and we used [Snakemake](https://snakemake.readthedocs.io/en/stable/) v.7.32.4. We wrote an _ad hoc_ [snakefile](./Scripts/alignment_trimming.smk) with a corresponding [configuration file](./Scripts/alignment_trimming_config.yaml) that we run with the option '--cores 30'.

Interestingly, the auto mode selected quite always the L-INS-i algorithm (same as '--localpair --maxiterate 1000'). Most of our proteins are indeed single domain, so it was the best decision.

The Snakemake approach was very successful since in only 10 minutes we could compute all alignments and two rounds of trimming of more than 550 OGs.

In order to be sure, we checked manually our trimmed alignmets and the completeness of our orthogroups ([count_perc_species_OG](../01_Orthlogy_inference_Paralog_filter/Scripts/count_perc_species_OG.sh)) in this case in the "after trimming" version. Indeed it quite was: only two orthogroups presented a completeness below 98%, but we maintained them in our concatenate, four presented 98% completeness, 264 99%, and the remnant was complete. No one lost the outgroup, since at least one species was always present.

Before moving on, we modified our orthogroups deleting the protein ID, leaving only species ID.

### Concatenation

Even if IQ-Tree did not need a concatenated gene matrix as input, we did it using [AMAS](https://github.com/marekborowiec/AMAS/tree/master) (downloading only the [Python script](https://github.com/marekborowiec/AMAS/blob/master/amas/AMAS.py)) because it would have been required by RAxML-NG.

We decided to write our partition both in format nexus and raxml (the first used in the IQ-tree inference). [General summary statistics](./Files/concat_summary.txt) and [per-species summary statistics](./Files/concat_summary_species.txt) of our alignment are available.

The resulting [matrix](./Files/species_tree_concat.zip) was 237116 bp long, with 33433356 cells, and 2.793% of the data were missing because undetermined. We had a really low percentage of variable sites, 0.437%, and half of those were parsimony informative ones (0.281%) (sites that provide information about evolutionary relationships between taxa in order to resolve trees).  

### ModelFinder and partition merging (IQ-tree)

IQ-tree (v 2.2.5) was used for the power of its [ModelFinder](https://www.nature.com/articles/nmeth.4285), in term of velocity of inference and variability of models. Thus, we launched ModelFinder enabling the partition merging.

The analysis took about 7 days (141 species, 578 genes MF+MERGE).

### Species tree inference (RAxML-NG)

We switched to [RAxML-NG](https://github.com/amkozlov/raxml-ng) (v1.20), a successor to the widely used RAxML, the very common program for tree inference to infer the real species tree.

We chose RAxML next generation due to its many benefits, first of all, the implementation of more protein substitution matrices, the same used by IQ-tree than the ones present for normal RAxML. Unluckily, RAxML-NG did not have yet a model selector implemented in its code, so we used IQ-tree's one laying on the advantage that IQ-tree model notations were readable by RAxML-NG.

Once we had our partition scheme inferred by IQ-Tree, we had to convert it into something readable by RAxML-NG, since it was not. Unluckily, we could not use the raxml scheme provided by IQ-Tree since it was adapted for the standard RAxML and not the NG one, so it was missing all the parameters inferred by IQ-Tree besides the model. Following the few examples we found on the internet, which reported that the structure had to look like this:

```text
model, partition_name = partition1
model, partition_name = partition2,partition3
```

we wrote a script able to convert Nexus format into raxml one ([partition_converter](.Scripts/partition_converter.sh)). A few changes were performed manually, since there was a subtle difference in the notation of the model JTT-DCMut, since RAxML-NG wanted a hyphen (JTTDCMut in IQ-Tree syntax). There was a model not provided by RAxML-NG: FLAV1. This particular substitution model was developed a few years ago and may be implemented in the following versions of RAxML-NG. Luckily, in similar cases the program allows using a user-defined matrix with the option "-m PROTGTR{substitution_matrix}". For this reason, we looked for the matrix in both its [original article](https://link.springer.com/article/10.1007/s00239-020-09943-3) and in [IQ-tree Git-hub](https://github.com/iqtree/iqtree2/blob/master/model/modelprotein.cpp).

When we had all settled up, before starting the real analysis, as suggested in RAxML-NG wiki page we ran the command with the "--parse" option. This generated a binary MSA loaded by the program much faster that showed estimated memory requirements and the recommended number of threads for the dataset.

```bash
raxml-ng --parse --msa species_tree_concat.fa --model <best_scheme.raxml>
```

Since we did not have to infer a complete tree, but only wanted to evaluate branch lengths and resolve a polytomy, we decided not to run RAxML in its default mode, but use the '--evaluation' one. To do it, we needed to provide a complete starting tree on which to perform the branch optimization. Because we had, actually, two of them, the one resolved by Oliveros and the one resolved by Kuhl, we provided both of them in two separate runs, intending to compare the resulting likelihood values and choose the one with the lowest one.

```bash
raxml-ng --msa <concat>.rba --tree <cladogram> --model <best_models.rax> --threads 15 --seed 3 --evaluate --outgroup Drnov,Cacas,Stcam
```

## Results

The following table resumes used time and likelihood values of the resulting trees.

|   tree   |    likelihood   |       BIC      | time |
|----------|-----------------|----------------|------|
|   Kuhl   | -3762468.785813 | 7535717.333065 | ~13h |
| Oliveros | -3762685.543153 | 7536150.847744 | ~13h |

The best tree, the one with the lowest likelihood value, was then the one that resolved the polytomy as Kuhl did in his paper. You can find it [here](./Files/species_tree_kuhl.nwk).

## Gene trees

Programs like TRACCER compare a species tree with single OG trees in order to check if there are any of the last ones that significantly differ from the general species tree. For this reason, we inferred a single tree for each OG computed by DISCO, and that passed the quality filter.

As we did in species tree inference, we could not rely on IQ-Tree as we hoped, so we had to use a hybrid approach using both IQ-Tree and RAxML-NG for the same reasons.

## Alignment with MAFFT (v7.490) and trimming with BMGE (v.1.12)

Filtered OGs inferred by DISCO were ready to be aligned. We, again, applied a process manager approach with Snakemake. This allowed a parallelized pipeline that speeded up orthogroups elaboration. To do it, we followed the same pipeline we develped for single copy complete orthogroups.

As before, we filtered these outputs through the filter already used after orthology inference, and only the resulting orthogroups were used to infer single gene trees.

## Model finder with IQ-tree (v.2.2.5) and tree inference with RAxML-NG (v.1.20)

We wrote a [Snakemake pipeline](./Scripts/gene_trees.smk) with its own [configuration](./Scripts/gene_trees.yaml) able to perform IQ-tree ModelFinder on each trimmed alignment, prune the cladogram based on species present, and infer branch length evaluation with the best model on the cladogram created. To do it, we wrapped all the single commands we performed above using the same parameters. For the second part of the pipeline, we had to create a [pruner.py](./Scripts/pruner.py) script and modify it in order to be implementable into snakefile, ([pruner_snake](./Scripts/pruner_snake.py)).
