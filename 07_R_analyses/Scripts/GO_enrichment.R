library(tidyverse)
library(topGO)

#Upload universe
gene_universe <- readMappings(file = "../../01_data/03_func_annotation/01_interpro/aves_interpro_GOback.txt")
geneUniverse <- names(gene_universe)

# Define genes of interest

## lifespan genes
long_lived <- read.table("LL_interesting.txt", header = F)
short_lived <- read.table("SL_interesting.txt", header = F)

##network
notext_11 <- list.files(path = '../07_selection/02_codeml/03_results/08_weight_control/string/notext_k11/', full.names = TRUE)
notext_biggest <- read.delim('../07_selection/02_codeml/03_results/08_weight_control/string/net_notext_k11.tsv', sep = "\t", skip = 1, colClasses = c("NULL", "NULL", "NULL", "NULL", "NULL", "character"), header = F)
colnames(notext_biggest) <- "V1"

#named list is an essential part to be able to interactively name the written tables.
biggest_list <- list('notext_biggest' = notext_biggest)
list_notext_11 <- setNames(lapply(notext_11, read.table), tools::file_path_sans_ext(basename(notext_11)))
list_notext_11 <- list_notext_11[-3] #deleted the list based on the column name "colour"

lifespan_genes <- list("long_lived" = long_lived, "short_lived" = short_lived)

GOenrichment <- function(trait, trait_name) {
  genesOfInterest <- as.character(trait$V1) #as vector not character 
  geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
  names(geneList) <- geneUniverse
  
  print(trait_name)
  
  ontology_values = c("BP", "MF", "CC")
  
  GOdata_list <- lapply(ontology_values, function(ontology_value) {
    GOdata_name <- paste("GOdata_", ontology_value, sep = "")
    # annot = annFUN.gene2GO this imparts the program which annotation it should use. In this case, it is specified that it will be in gene2GO format and provided by the user.
    # gene2GO = gene_universe is the argument used to tell where is the annotation
    assign(GOdata_name, new("topGOdata", ontology=ontology_value, allGenes=geneList, annot = annFUN.gene2GO, gene2GO = gene_universe))
  })
  
  elim_list <- lapply(seq_along(ontology_values), function(i) {
    elim_name <- paste("elim_", ontology_values[i], sep="")
    assign(elim_name, runTest(GOdata_list[[i]], algorithm="elim", statistic="fisher"))
  })
  
  results_elim <- function(GO_data, elim_data) {
    resulte <- GenTable(GO_data, Classic_Fisher = elim_data, orderBy = "Classic_Fisher", topNodes=1000, numChar=1000)
    resulte$Classic_Fisher <- as.numeric(resulte$Classic_Fisher)
    resulte <- subset(resulte, Classic_Fisher < 0.05)
    return(resulte)
  }
  
  results_elim_list <- lapply(seq_along(ontology_values), function(i) {
    resulte_name <- paste("resulte_", ontology_values[i], sep="")
    assign(resulte_name, envir = .GlobalEnv, results_elim(GOdata_list[[i]], elim_list[[i]]))
  })
  
  write_elim_results <- function(result, ontology_value, trait_name) {
    table_name <- paste("02_enrichment/topGOe_", trait_name, "_", ontology_value, ".txt", sep="")
    write.table(result, file=table_name, quote=F, sep = "\t", row.names = F)
  }
  
  lapply(seq_along(ontology_values), function(i) {
    write_elim_results(results_elim_list[[i]], ontology_values[i], trait_name)
  })
}

#Complete function to perform enrichment
##this particular syntax has been necessary since it was impossible to give the function the trait name it was computing.
GO_enrichment <- function(list) {
  lapply(seq_along(list), function(i) {
  GOenrichment(list[[i]], names(list)[i])
  })
}

#Run the complete function
GO_enrichment(list_notext_11)