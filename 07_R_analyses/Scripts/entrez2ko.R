#This script aims to transform the first column of the geneage and cellage databases, the entrez ID, into its correspoding ko term in order to be able to better confront already known genes in humans with their respectives in other animals

#Libraries
library(KEGGREST)
library(dplyr)

#load databases
cellage <- read.delim("../../01_data/02_dataset/cellAge/cellage3.tsv")
genage_human <- read.csv("../../01_data/02_dataset/human_genes/genage_human.csv")
genage_models <- read.csv("../../01_data/02_dataset/models_genes/genage_models.csv")

#function to obtain ko
entrez2ko <- function(entrez) {
  ncbi <- paste("ncbi-geneid", entrez, sep = ":")
  print(paste("Searching for", ncbi, sep = " "))
  id <- keggConv("genes", ncbi)
  if (length(id) == 0){
  #using sapply it is important to return NA and not "NA" because otherwise it will be converted in NULL in order to simplify the resultant vector
    return(NA)
  } else {
    kegg <- keggGet(id[ncbi])
    ortho <- names(kegg[[1]]$ORTHOLOGY)
  # sometime even if the kegg exists the orthology may be absent  
    if (length(ortho) == 0) {
      return(NA)
    } else {
      return(ortho)
    }
  }
}

#elaborate the databases
#cellage$KO <- unlist(sapply(cellage$Entrez.ID, entrez2ko))
#print("CellAge terminated, writing results...")
#write.table(cellage, "../../01_data/02_dataset/cellAge/cellage3_ko.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

genage_human$KO <- unlist(sapply(genage_human$entrez.gene.id, entrez2ko))
print("GenAge human terminated, writing results...")
write.table(genage_human, "../../01_data/02_dataset/human_genes/genage_human_ko.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

genage_models$KO <- unlist(sapply(genage_models$entrez.gene.id, entrez2ko))
print("GenAge models terminated, writing results...")
write.table(genage_models, "../../01_data/02_dataset/models_genes/genage_models_ko.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
