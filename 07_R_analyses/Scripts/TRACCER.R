library(tidyverse)
library(ggplot2)

# MLS
MLSLL <- read.table(file='MLSLL_pvalue_complete.tsv')
MLSLL$Legend <- ifelse(MLSLL$V2 == "MLSLL_pesato", "Phylogenetic control", ifelse(MLSLL$V2 == "MLSLL", "MLSLL", ifelse(MLSLL$V2 == "weight_control", "Weight control", "Random control")))

ggplot(MLSLL, aes(x = V1, fill = factor(Legend, levels = c("Random control","Phylogenetic control", "Weight control", "MLSLL")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("MLSLL" = "blue", "Phylogenetic control" = "red", "Weight control" = "green", "Random control" = "black")) +
  guides(fill = guide_legend(reverse = TRUE, title.position = "top", title.hjust=0.5))+
  labs(fill = "MLSLL groups", x="p-values", y="Density") +
  ggtitle("MLSLL") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size = 18), axis.text = element_text(size = 14), axis.line = element_line(size=0.7), legend.position = "bottom", legend.box = "vertical", legend.text = element_text(size=15), legend.title = element_text(size=16)) 

#MLSSL
MLSSL <- read.table(file='MLSSL_pvalue_complete.tsv')
MLSSL$Legend <- ifelse(MLSSL$V2 == "MLSSL_pesato", "Phylogenetic control", ifelse(MLSSL$V2 == "MLSSL", "MLSSL", ifelse(MLSSL$V2 == "weight_control", "Weight control", "Random control")))

#The order should be in the opposite way than the one is expected since the program builds the graph from the bottom to the top, adding one layer after the other putting it above the previous one
ggplot(MLSSL, aes(x = V1, fill = factor(Legend, levels = c("Random control","Phylogenetic control", "Weight control", "MLSSL")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("MLSSL" = "blue", "Phylogenetic control" = "red", "Weight control" = "green", "Random control" = "black")) +
  labs(fill = "Distribution", x="p-values", y="Density") +
  guides(fill = guide_legend(reverse = TRUE, title.position = "top", title.hjust=0.5))+
  ggtitle("MLSSL") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size = 18), axis.text = element_text(size = 14), axis.line = element_line(size=0.7), legend.position = "bottom", legend.box = "vertical", legend.text = element_text(size=15), legend.title = element_text(size=16))

#LQLL20
LQLL20 <- read.table(file="LQLL20_pvalues.txt", sep = "\t")
LQLL20$Legend <- ifelse(LQLL20$V2 == "LQLL20 weighted", "Weighted control", ifelse(LQLL20$V2 == "LQLL20", "Test analysis", "Random controls"))

ggplot(LQLL20, aes(x = V1, fill = factor(Legend, levels = c("Random controls","Weighted control","Test analysis")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("Test analysis" = "blue", "Weighted control" = "red", "Random controls" = "black")) +
  guides(fill = guide_legend(reverse = TRUE, title.position = "top", title.hjust=0.5))+
  labs(fill = "Distribution", x="p-values", y="Density") +
  ggtitle("LQLL") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size = 18), axis.text = element_text(size = 14), axis.line = element_line(size=0.7), legend.position = "none", legend.box = "vertical", legend.text = element_text(size=15), legend.title = element_text(size=16)) 

#LQSL
LQSL <- read.table(file="LQSL_pvalues.txt", sep="\t")
LQSL$Legend <- ifelse(LQSL$V2 == "LQSL weighted", "Weighted control", ifelse(LQSL$V2 == "LQSL", "Test analysis", "Random controls"))

ggplot(LQSL, aes(x = V1, fill = factor(Legend, levels = c("Random controls","Weighted control","Test analysis")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("Test analysis" = "blue", "Weighted control" = "red", "Random controls" = "black")) +
  guides(fill = guide_legend(reverse = TRUE, title.position = "top", title.hjust=0.5))+
  labs(fill = "Distribution", x="p-values", y="Density") +
  ggtitle("LQSL") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size = 18), axis.text = element_text(size = 14), axis.line = element_line(size=0.7), legend.position = "none", legend.box = "vertical", legend.text = element_text(size=15), legend.title = element_text(size=16)) 

#LQLL175
LQLL175 <- read.table(file="LQLL175_pvalues.txt", sep = "\t")

ggplot(LQLL175, aes(x = V1, fill = factor(V2, levels = c("LQLL175 random","LQLL175 weighted","LQLL175")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("LQLL175" = "blue", "LQLL175 weighted" = "red", "LQLL175 random" = "black")) +
  guides(fill = guide_legend(reverse = TRUE))+
  labs(fill = "MLSLL groups", x="p-values") +
  ggtitle("LQLL175") +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))

#LQLL15
LQLL15 <- read.table(file="LQLL15_pvalues.tx  ", sep = "\t")

ggplot(LQLL15, aes(x = V1, fill = factor(V2, levels = c("LQLL15 random","LQLL15 weighted","LQLL15")))) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("LQLL15" = "blue", "LQLL15 weighted" = "red", "LQLL15 random" = "black")) +
  guides(fill = guide_legend(reverse = TRUE))+
  labs(fill = "MLSLL groups", x="p-values") +
  ggtitle("LQLL15") +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))

#Kolmogorov-Smirnov test 
kolsmi_MLS <- lapply(1:10, function(n) {
  column_name <- sprintf("MLSLL_control%02d", n)
  total_result <- ks.test(MLS$V1[MLS$V2 == "MLSLL"],MLS$V1[MLS$V2 == column_name], alternative="greater")
  acc_result <- ks.test(MLSacc$V1[MLSacc$V2 == "MLSLL"],MLSacc$V1[MLSacc$V2 == column_name], alternative="greater")
  con_result <- ks.test(MLScon$V1[MLScon$V2 == "MLSLL"],MLScon$V1[MLScon$V2 == column_name], alternative="greater")
  return(list(total=total_result,acc=acc_result,con=con_result))
})

kolsmi_MLSSL <- lapply(1:10, function(n) {
  column_name <- sprintf("MLSSL_control%02d", n)
  total_result <- ks.test(MLSSL$V1[MLSSL$V2 == "MLSSL"],MLSSL$V1[MLSSL$V2 == column_name], alternative="greater")
  acc_result <- ks.test(MLSSLacc$V1[MLSSLacc$V2 == "MLSSL"],MLSSLacc$V1[MLSSLacc$V2 == column_name], alternative="greater")
  con_result <- ks.test(MLSSLcon$V1[MLSSLcon$V2 == "MLSSL"],MLSSLcon$V1[MLSSLcon$V2 == column_name], alternative="greater")
  return(list(total=total_result,acc=acc_result,con=con_result))
})

kolsmi_LQLL20 <- lapply(1:10, function(n) {
  column_name <- sprintf("LQLL20_control%02d", n)
  total_result <- ks.test(LQLL20$V1[LQLL20$V2 == "LQLL20"],LQLL20$V1[LQLL20$V2 == column_name], alternative="greater")
  acc_result <- ks.test(LQLL20acc$V1[LQLL20acc$V2 == "LQLL20"],LQLL20acc$V1[LQLL20acc$V2 == column_name], alternative="greater")
  con_result <- ks.test(LQLL20con$V1[LQLL20con$V2 == "LQLL20"],LQLL20con$V1[LQLL20con$V2 == column_name], alternative="greater")
  return(list(total=total_result,acc=acc_result,con=con_result))
})

kolsmi_LQSL <- lapply(1:10, function(n) {
  column_name <- sprintf("LQSL_control%02d", n)
  total_result <- ks.test(LQSL$V1[LQSL$V2 == "LQSL"],LQSL$V1[LQSL$V2 == column_name], alternative="greater")
  acc_result <- ks.test(LQSLacc$V1[LQSLacc$V2 == "LQSL"],LQSLacc$V1[LQSLacc$V2 == column_name], alternative="greater")
  con_result <- ks.test(LQSLcon$V1[LQSLcon$V2 == "LQSL"],LQSLcon$V1[LQSLcon$V2 == column_name], alternative="greater")
  return(list(total=total_result,acc=acc_result,con=con_result))
})

#ECDS
ggplot(MLSLL, aes(x = V1, color = factor(Legend, levels = c("MLSLL random","MLSLL weighted","MLSLL")))) +
  stat_ecdf()+
  scale_color_manual(values = c("black","red","blue")) +
  guides(color = guide_legend(reverse = TRUE))+
  labs(color = "MLSLL groups", x="p-values") +
  ggtitle("MLSLL ECDF") +
  coord_cartesian(xlim = c(0, 0.1), ylim=c(0,0.175)) +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))

ggplot(MLSSL, aes(x = V1, color = factor(Legend, levels = c("MLSSL random","MLSSL weighted","MLSSL")))) +
  stat_ecdf() +
  scale_color_manual(values = c("MLSSL" = "blue", "MLSSL weighted" = "red", "MLSSL random" = "black")) +
  guides(color = guide_legend(reverse = TRUE))+
  labs(color = "MLSSL groups", x="p-values") +
  ggtitle("MLSSL ECDF") +
  coord_cartesian(xlim = c(0, 0.1), ylim=c(0,0.175)) +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))

ggplot(LQLL20, aes(x = V1, color = factor(V2, levels = c("LQLL20 random","LQLL20 weighted","LQLL20")))) +
  stat_ecdf() +
  scale_color_manual(values = c("LQLL20" = "blue", "LQLL20 weighted" = "red", "LQLL20 random" = "black")) +
  guides(color = guide_legend(reverse = TRUE))+
  labs(color = "MLSLL groups", x="p-values") +
  ggtitle("LQLL20 ECDF") +
  coord_cartesian(xlim = c(0, 0.1), ylim=c(0,0.125)) +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))

ggplot(LQSL, aes(x = V1, color = factor(V2, levels = c("LQSL random","LQSL weighted","LQSL")))) +
  stat_ecdf() +
  scale_color_manual(values = c("LQSL" = "blue", "LQSL weighted" = "red", "LQSL random" = "black")) +
  guides(color = guide_legend(reverse = TRUE))+
  labs(color = "MLSLL groups", x="p-values") +
  ggtitle("LQSL ECDF") +
  coord_cartesian(xlim = c(0, 0.1), ylim=c(0,0.125)) +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 24))