#import libraries
library(geiger)
library(castor)
library(ggplot2)
library(phytools)
library(tidyverse)
library(readr)
library(phylobase)

#read Aves
Aves <- read_csv("aves.csv") %>% filter(!is.na(LQ)) %>% select(-c(LQ, 'e-MLS'))
aves_lm <- lm(log(MLS) ~ log(Weight), data = Aves)
Aves <- Aves %>% mutate(e_mLS = exp(predict(aves_lm)), LQ = round(MLS/e_mLS, digits = 2))
#plot lm
Aves %>% ggplot(aes(x = log(Weight), y = log(MLS))) + geom_point() + geom_smooth(method = 'lm') + xlab("ln[Weight (grams)]") + ylab("ln[MLS (years)]") + theme_classic() + theme(axis.title = element_text(size = 12), axis.text = element_text(size = 12), axis.line = element_line(size = 0.7))

#upload Aves tree (from TimeTree.org)
aves_tree <- read.tree(file = "aves_complete.nwk")
is.ultrametric(aves_tree) #FALSE
aves_tree <- force.ultrametric(aves_tree, method = "extend")
is.ultrametric(aves_tree) #TRUE

# upload species tree
aves_tree_genome <- read.tree(file = "species_tree_genome.nwk")
is.rooted(aves_tree_genome) #TRUE
aves_s4tree_genome <- as(aves_tree_genome, "phylo4")
hasPoly(aves_s4tree_genome) #FALSE. no structural polytomies
any(edgeLength(aves_s4tree_genome) == 0) #NA
hasSingle(aves_s4tree_genome) #FALSE. all edges are at least dichotomous
hasRetic(aves_s4tree_genome) #FALSE. there are not reticulations (nodes with more than one ancestors)

#PIC
#name check trait-tree and pruning if necessary
aves_LQ <- Aves %>% unite(col = "s_name", c("Genus", "Species"), sep = "_") %>% pull(var = LQ, name = s_name)
aves_diff_names <- name.check(aves_tree, aves_LQ)
aves_LQ_tree <- drop.tip(aves_tree, aves_diff_names$tree_not_data)
#create pic vectors
aves_MLS <- Aves %>% unite(col = "s_name", c("Genus", "Species"), sep = "_") %>% pull(var = MLS, name = s_name)
aves_MLS_pruned <- aves_MLS[aves_LQ_tree$tip.label]
aves_Weight <- Aves %>% unite(col = "s_name", c("Genus", "Species"), sep = "_") %>% pull(var = Weight, name = s_name)
aves_weight_pruned <- aves_Weight[aves_LQ_tree$tip.label]
aves_pic_MLS <- pic(log(aves_MLS_pruned), aves_LQ_tree)
aves_pic_weight <- pic(log(aves_weight_pruned), aves_LQ_tree)
aves_fit_pic <- lm(aves_pic_MLS ~ aves_pic_weight+0)
## graph scatterplot of contrasts
par(mar=c(5.1,5.1,1.1,1.1))
plot(aves_pic_MLS~aves_pic_weight, xlab="PICs for log(Weight)",ylab="PICs for log(MLS)",pch=21,bg="gray",cex=1.2,las=1,cex.axis=0.7,cex.lab=0.9,bty="n")
abline(h=0,lty="dotted")
abline(v=0,lty="dotted")
clip(min(aves_pic_weight),max(aves_pic_weight),min(aves_pic_MLS),max(aves_pic_MLS))
abline(aves_fit_pic,lwd=2,col="black")

#ppca
## libraries
library(tibble)
library(phytools)
library(ggplot2)

##analysis
aves_genomes <- Aves %>% filter(s_name %in% aves_tree_genome$tip.label)
complete_data_genomes <- aves_genomes %>% select(s_name, MLS, Weight) %>% column_to_rownames(var='s_name')
aves_ppca_lndata <- scale(log(complete_data_genomes))
aves_ppca_phy <- phyl.pca(aves_tree_genome, aves_ppca_lndata)
aves_ppca_phylo_scores <- -1*(as.data.frame(aves_ppca_phy[["S"]]))
aves_ppca_phylo_scores$label <- ifelse(aves_ppca_phylo_scores$PC1 > 0 & aves_ppca_phylo_scores$PC2 > 0, "ELL & 3L", ifelse(aves_ppca_phylo_scores$PC1 > 0, "ELL", ifelse(aves_ppca_phylo_scores$PC2 > 0, "3L", "not long-lived"))) #sign flipped for easiness of reading and because it is common practice to have positive = long-lived
ggplot(aves_ppca_phylo_scores, aes(x=PC1, y=PC2, color=label)) + 
  geom_point() + 
  scale_color_manual(values = c("3L" = "blue", "ELL" = "red", "ELL & 3L" = "purple", "not long-lived" = "black" )) +
  ggtitle("phylogenetic PCA") +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24), axis.title = element_text(size = 16), axis.text = element_text(size = 14))
aves_ELL_species <- row.names(aves_ppca_phylo_scores %>% filter(PC1 > 0))
aves_3L_species <- row.names(aves_ppca_phylo_scores %>% filter(PC2 > 0))
s.corcircle(-1*(aves_ppca_phy$L)) # sign flipped to match scores

##plot
aves_ELL_plot <- ggplot(aves_ppca_phylo_scores, aes(y = row.names(aves_ppca_phylo_scores), x=PC1, fill = factor(sign(PC1)))) +
  geom_bar(stat = "identity", position = "identity", width = 0.7) +
  scale_fill_manual(values = c("red", "green")) +
  labs(title = "ELL", x = "PC1 scores", y = "Species names") +
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 6)) +
  scale_y_discrete(limits = rev(levels(as.factor(row.names(aves_ppca_phylo_scores)))))
aves_3L_plot <- ggplot(aves_ppca_phylo_scores, aes(y = row.names(aves_ppca_phylo_scores), x=PC2, fill = factor(sign(PC2)))) +
  geom_bar(stat = "identity", position = "identity", width = 0.7) +
  scale_fill_manual(values = c("red", "green")) +
  labs(title = "3L", x = "PC2 scores", y = "Species names") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 6)) +
  scale_y_discrete(limits = rev(levels(as.factor(row.names(aves_ppca_phylo_scores)))))

#MLS_quantiles
quantile(Aves$MLS, 0.75) #24.5 (inferred root ancestor all Aves 17)
quantile(Aves$MLS, 0.25) #10
quantile(aves_genomes$MLS, 0.75) #27
quantile(aves_genomes$MLS, 0.25) #11.1
aves_genome %>% filter(MLS <= 11.1) #36
aves_MLSSL_species <- aves_genome %>% filter(MLS <= 11.1)
aves_MLSSL_species <- aves_MLSSL_species$s_name

#Weight quantile
quantile(aves_genome$Weight, 0.75) #1078 / 35 birds (17 LL, 16 NL, 2 SL)
quantile(aves_genome$Weight, 0.25) #25.6 / 36 birds (18 NL, 18 SL)
aves_heavy_name <- aves_genome$s_name[aves_genome$Weight > 1078 & aves_genome$MLS <= 27]
aves_light_name <- aves_genome$s_name[aves_genome$Weight <= 25.6 & aves_genome$MLS > 11.1]

#Selection
##codeml
codeml_result <- read.delim('LRT_lifespan_genes.tsv')
codeml_result <- codeml_result %>% filter(significance == "Significant")
ggplot(codeml_result, aes(x=TRACCER, y=deltaw, fill=significance)) + 
  geom_boxplot() + 
  facet_wrap(~Trait, labeller = labeller(Trait = c("LL" = bquote(MLS[LL]), "SL" = "MLSSL"))) + 
  #scale_fill_manual(values = c("Significant" = "dodgerblue", "Not significant" = "orange")) +
  theme_bw() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(fill = "LRT significance", x="TRACCER", y="Δω") +
  theme(axis.title = element_text(size = 16), axis.text = element_text(size = 12), axis.line = element_line(linewidth=0.7), legend.text = element_text(size=13), legend.title = element_text(size=16), strip.text = element_text(size = 16))

#Summary tables for figures
library(ggpubr)

##sum table for MLS
sum_MLS <- data.frame(
  'Metrics' = c("Total species", "n° orders", "Maximum", "Minimum"),
  'Long-Lived' = c(35, 10, 84.0, 27.2),
  'Short-Lived' = c(36, 16, 11.1, 4.0)
)

sum_MLS <- t(sum_MLS)
sum_MLS <- as.data.frame(sum_MLS)
colnames(sum_MLS) <- sum_MLS[1, ]  # Set first row as column names
sum_MLS <- sum_MLS[-1, ]
rownames(sum_MLS) <- c("Long-Lived","Short-Lived")

table_plot <- ggtexttable(sum_MLS, theme = ttheme("light"))
ggsave("table.svg", plot = table_plot, width = 6, height = 4)

##sum table for significance analysis network
sum_significance <- data.frame(
  'Metrics' = c("Force", "Trait", "Multi", "Anage"),
  'Stress' = c(format(0.1052, scientific = TRUE), format(0.01400, scientific = TRUE), format(0.1442, scientific = TRUE), format(0.008078, scientific = TRUE)),
  'Degree' = c(format(0.5646, scientific = TRUE), format(0.2062, scientific = TRUE), format(0.01698, scientific = TRUE), format(0.002414, scientific = TRUE))
)

sum_significance <- t(sum_significance)
sum_significance <- as.data.frame(sum_significance)
colnames(sum_significance) <- sum_significance[1, ]  # Set first row as column names
sum_significance <- sum_significance[-1, ]
rownames(sum_significance) <- c("Stress","Degree")

table_plot <- ggtexttable(sum_significance, theme = ttheme("light"))
ggsave("table.svg", plot = table_plot, width = 6, height = 4)

##sum table for gene of interest
sum_genes <- data.frame(
  'Gene' = c("Degree\n(>4)", "Stress\n(>4998.5)", "Anage", "Anage\nHuman"),
  'ADH5' = c("V","V","X","X"),
  'ANAPC1' = c("V","V","V","X"),
  'ANAPC5' = c("V","X","V","X"),
  'CBLB' = c("V","X","X","X"),
  'FGFR1' = c("V","V","V","V"),
  'GNE' = c("X","V","X","X"),
  'HPGD' = c("X","V","X","X"),
  'INSR' = c("V","X","V","V"),
  'KAT2B' = c("X","V","V","X"),
  'MRTFA' = c("X","V","V","X"),
  'NT5C1A' = c("V","X","X","X"),
  'NUDT15' = c("X","V","X","X"),
  'PIK3R3' = c("V","X","V","V"),
  'PLK4' = c("X","V","X","X"),
  'PTPN11' = c("V","X","V","V"),
  'SCP2' = c("X","V","X","X"),
  'SUCLG2' = c("X","V","V","X"),
  'TAF5' = c("V","V","X","X"),
  'TKT' = c("X","V","X","X"),
  row.names = NULL
)

sum_genes <- t(sum_genes)
sum_genes <- as.data.frame(sum_genes)
colnames(sum_genes) <- sum_genes[1, ]  # Set first row as column names
sum_genes <- sum_genes[-1, ]

table_plot <- ggtexttable(sum_genes, theme = ttheme("light"))
ggsave("table.svg", plot = table_plot, width = 20, height = 5)