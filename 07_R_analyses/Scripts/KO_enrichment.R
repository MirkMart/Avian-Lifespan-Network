library(clusterProfiler)
library(enrichplot)
library(data.table)

#orthologues universe
allKO=read.table("../../01_data/03_func_annotation/00_eggNOG/aves_KO_orthologue_universe.txt",header=FALSE)

#pathways universe
allpath=read.table("../../01_data/03_func_annotation/00_eggNOG/aves_KO_pathway_universe.txt",header=FALSE)

## network
notext_11 <- list.files(path = '../07_selection/02_codeml/03_results/08_weight_control/string/notext_k11/', full.names = TRUE)
notext_biggest <- read.delim('../07_selection/02_codeml/03_results/08_weight_control/string/net_notext_k11.tsv', sep = "\t", skip = 1, colClasses = c("NULL", "NULL", "NULL", "NULL", "NULL", "character"), header = F)
colnames(notext_biggest) <- "V1"

#named list is an essential part to be able to interactively name the written tables.

biggest_list <- list('notext_biggest' = notext_biggest)
list_notext_11 <- setNames(lapply(notext_11, read.table), tools::file_path_sans_ext(basename(notext_11)))
list_notext_11 <- list_notext_11[-3] #deleted the list based on the column name "colour"

#function to infer KO and pathway enrichments
KOenrichment <- function(trait, trait_name, path_universe, KO_universe, dir, q_value=0.05, AdjustMethod="BH") {
  geneList=as.vector(trait$V1)
  
  print(trait_name)

  pathway_enrich <- function(gene_list, path_universe, trait_name, q_cutoff, adjmethod, dir) {
    enrich=enricher(gene_list, TERM2GENE=path_universe, pvalueCutoff = 0.05, pAdjustMethod = adjmethod, qvalueCutoff = q_cutoff, minGSSize = 1)
    table_name <- paste(dir, "path_", trait_name, ".txt", sep="")
    write.table(enrich, file=table_name, quote=F, sep = "\t", row.names = F)
  }
  
  KO_enrich <- function(gene_list, KO_universe, trait_name, q_cutoff, adjmethod, dir) {
    enrich=enricher(gene_list, TERM2GENE=KO_universe, pvalueCutoff = 0.05, pAdjustMethod = adjmethod, qvalueCutoff = q_cutoff, minGSSize = 1)
    table_name <- paste(dir, "KO_", trait_name, ".txt", sep="")
    write.table(enrich, file=table_name, quote=F, sep = "\t", row.names = F)
  }
  
  pathway_result <- pathway_enrich(geneList, path_universe, trait_name, q_value, AdjustMethod, dir)
  
  KO_result <- KO_enrich(geneList, KO_universe, trait_name, q_value, AdjustMethod, dir)
  
}

#complete function
##this particular syntax has been necessary since it was impossible to give the function the trait name it was computing.
KO_enrichment <- function(list, dir) {
  lapply(seq_along(list), function(i) {
  KOenrichment(list[[i]], names(list)[i], allpath, allKO, dir)
  })
}

#run complete function
KO_enrichment(list_notext_11, "02_enrichment/03_KO/")

# https://yulab-smu.top/biomedical-knowledge-mining-book/clusterprofiler-kegg.html