# Longevity_in_aves

![Aves_cover](./01_data/Images/species_tree_completename.png "aves_cover")

This repository represents the pipeline we developed for the the work "Avian Lifespan Network Reveals Common Mechanisms and Identifies New Key Players in Animal Longevity". Here, we focus our attention on birds, a class of vertebrate animals that is gaining importance in longevity studies.

This repository contains:

- [00_scripts](./00_scripts/). It contains all script we used and wrote for our analyses.
  - [00_snakemake](./00_scripts/00_snakemake/) contains all snakemake pipelines, [conda environments](./00_scripts/00_snakemake/00_conda/), and [snakescript](./00_scripts/00_snakemake/01_scripts/) wrote to optimise the workflow.
- [01_data](./01_data/). It contains all the data raw and partially elaborated that constituted the start of our work.
  - [01_CDS](./01_data/01_CDS/) filled with genomes and extracted CDS.
  - [02_dataset](./01_data/02_dataset/) which contains the various datasets and lists of species.
  - [03_func_annotation](./01_data/03_func_annotation/) which contains functional annotations perfomed with different tools.
- [02_analysis](./02_analysis/). This folder contains all the analyses we performed
  - [00_R](./02_analysis/00_R/). Here are described and performed all the analyses using R and R studio, from the most common descriptive analyses to the ancestral state reconstrunction and functional enrichments.
  - [01_Busco](./02_analysis/01_Busco/).
  - [02_Orthology](./02_analysis/02_Orthology/). Here are saved orthofinder results and subsequent input elaboration, like DISCO decomposition.
  - [04_Trees](./02_analysis/04_Trees/). This folder contains all the analyses that had as their main result the inference of a phylogenetic tree: species, gene, or time.
  - [05_TRACCER](./02_analysis/05_TRACCER/). Here are described and stored the results of convergent evolution analyses using TRACCER.
  - [06_Summary](./02_analysis/06_Summary/). In this files are described the hypothesis we had about the signficance of the results we found with GO enrichments and STRING analyses. Moreover, are listed the identities of the genes taken into consideration.
  - [07_selection](./02_analysis/07_selection/). This folder contains the selective force analyses perfomed with codeml and RELAX.
- [03_Master_thesis](./03_Master_thesis/) Mirko Martini's Master's degree thesis wrote starting from the results of this repository up to the analyses of TRACCER results.
- [04_past_README](./04_past_README/). This is the second attempt of this entire pipeline. The re-run was done since we forgot to eliminate pseudogenes during the first attempt. The new files are written to be autonomous and complete, but this folder contains readme files that explain how the analyses were performed before. This folder could be interesting for the comparison we did between DISCO and PhyloPyPruner paralogs decomposition which we did not perform a second time with the second dataset.
- [98_todo](./98_todo.md). This is a file were we temporary stored information and steps we thought important to perform but that did not find immediatly a place inside the folders and files listed above.
- [99_thoughts](./99_thoughts.md). This is a file were we stored information and ideas we had while talking about the project but that did not find immediatly a place inside the folders and files listed above.

An easier path to follow regarding the main steps of our project:

- [Genomic data collection and elaboration](./01_data/README.md).
- [Orthology inference](./02_analysis/02_Orthology/README.md).
<!-- - [Gene family evolution](./02_analysis/03_CAFE/README.md). -->
- [Gene evolution and convergence](./02_analysis/05_TRACCER/README.md)
- [Functional enrichments](./02_analysis/00_R/Functional_enrichment.md)
<!-- - [Ancestral state reconstruction of longevity phenotypes and comparative methods](/02_analysis/00_R/Ancestral_state_reconstruction.md). -->
- [Deeper analyses of interesting genes and STRING](/02_analysis/06_Summary/README.md)

[![Snakemake](https://img.shields.io/badge/snakemake-≥5.6.0-brightgreen.svg?style=flat)](https://snakemake.readthedocs.io)
