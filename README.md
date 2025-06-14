# Longevity_in_aves

This repository represents the pipeline we developed for the the work "Avian lifespan network reveals shared mechanisms and new key players in animal longevity". Here, we focus our attention on birds, a class of vertebrate animals that is gaining importance in longevity studies.

The repository contains:

- [01_Data_Collection](./01_Data_Collection): how data were collected, parsed, and prepared to be used.
- [02_Orthlogy_inference_Paralog_filter](./02_Orthlogy_inference_Paralog_filter): how orthogology inference was carried on and its results. In this folder are also present all the trimmed alignments of amino acid sequences that were used during this work.
- [03_Species_Gene_Trees](./03_Species_Gene_Trees): how we inferred species and gene trees used as inputs of the convergence analysis.
- [04_Convergence_analysis](./04_Convergence_analysis): how we perfomed the convergence analysis using TRACCER.
- [05_Codon-based_selection_analysis](./05_Codon-based_selection_analysis): how we carried on the codon-based selection anaylsis inferring the evolutionary force shaping convergently evolving amino acid sequences.
- [06_Network](./06_Network): how we used the results of these evolutionary analysis to construct the lifespan network and how we elaborated it.
- [07_R_analyses](./07_R_analyses): how we perfomed more general analysis and visualized results displayed in the work using mainly R scripts.

All the folders contain the scripts and the main input files needed to perfomed the passages described in the respective README files.
