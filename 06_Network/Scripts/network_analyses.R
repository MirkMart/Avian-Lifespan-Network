library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(gtools)

setwd("/home/STUDENTI/mirko.martini/Documenti/GitHub/Longevity_in_aves/02_analysis/00_R")

#Read the analysis results from complete (several networks)
notext_complete <- read.csv('../07_selection/02_codeml/03_results/08_weight_control/string/notext_complete_analysed.csv')
notext_single_anal <- split(notext_complete, notext_complete$color)
notext_red <- notext_single_anal[["Red"]]

#read analysis result for single network
notext_red <- read.csv('../07_selection/02_codeml/03_results/08_weight_control/string/anal_notext_red.csv')

#Convert from wide to long format and duplicate rows with multi == 2 (those are common genes between different evolutionary conditions)
reformat_table_net_analyses <- function(df) {
  column_of_interest = c('BetweennessCentrality', 'Stress', 'AverageShortestPathLength', 'ClosenessCentrality', 'Radiality', 'Degree', 'Eccentricity', 'ClusteringCoefficient', 'NeighborhoodConnectivity', 'TopologicalCoefficient')
  
  #duplicate row if necessary
  expanded_df <- df
  for (row in 1:nrow(df)) {
    if (df[row, "multi"] == 2) {
      new_row <- df[row, ]
      new_row$trait <- ifelse(new_row$trait == "LL", "SL", "LL")
      new_row$force <- ifelse(new_row$force == "a", "c", "a")
      expanded_df <- rbind(expanded_df, new_row)
    }
  }
  expanded_df$multi <- as.character(expanded_df$multi)
  assign(paste0("expanded_", deparse(substitute(df))), expanded_df, envir = .GlobalEnv)
  
  #from short format to long format
  long_table <- expanded_df %>% pivot_longer(cols = all_of(column_of_interest), names_to = "Metric", values_to = "Value")
  assign(paste0("long_", deparse(substitute(df))), long_table, envir = .GlobalEnv)
}

reformat_table_net_analyses(text_red)
reformat_table_net_analyses(text_complete)
reformat_table_net_analyses(notext_red)
reformat_table_net_analyses(notext_complete)

#plot the studied metrics
net_metrics_plot <- function(df, x, fill){
  main_title <- paste("Boxplots of Metrics by Group -", str_to_title(x), if(x != fill) paste("&", str_to_title(fill)))
  
  ggplot(df, aes_string(x = x, y = "Value", fill = fill)) +
  geom_boxplot() +
  facet_wrap(~ Metric, scales = "free") +
  theme_minimal() +
  labs(x = "Group", y = "Metric Value", title = main_title)
}

net_metrics_plot(long_notext_complete, "multi", "multi")

#create function to elaborate network based on groups and columns of interest
##compute statistical analyses of metrics of interest
sig_diff_net_metrics <- function(df, group, group2 = 'none', correc_method = "none", word = "no") {
  #Create list where store results
  results_list <- list()
   
  #list interesting columns and make them numeric
  column_of_interest <- c('BetweennessCentrality', 'Stress', 'AverageShortestPathLength', 'ClosenessCentrality', 'Radiality', 'Degree', 'Eccentricity', 'ClusteringCoefficient', 'NeighborhoodConnectivity', 'TopologicalCoefficient')
  
  for (col in column_of_interest) {
    df[[col]] <- as.numeric(df[[col]])
  }
  
  #Extract unique values of group column
  val1 <- unique(df[[group]])[1]
  val2 <- unique(df[[group]])[2]
  
  #If a second column is not provided, run the function in the simpler way (e.g., c vs a, or LS vs LL)
  if (group2 == 'none') {
    #initialise list where store hypothesis of greatness
    means_list <- list()
    
    #initialise vector to store results
    p_values <- numeric(length(column_of_interest))
    names(p_values) <- column_of_interest

    for (col in column_of_interest) {
      #print(col) #debug
      #skip the column if it has all equal values. Statistical tests cannot be computed otherwise
      if (length(unique(df[[col]][df[[group]] == val1])) > 1 & length(unique(df[[col]][df[[group]] == val2])) > 1) {
        #compute alternative hypotheses
        mean1 <- mean(df[[col]][df[[group]] == val1])
        mean2 <- mean(df[[col]][df[[group]] == val2])
        alt <- if ((mean1 - mean2) >= 0) "greater" else "less"

        #add hypothesis to means_list
        means_list[[col]] <- sprintf("%s%s%s", val1, ifelse(alt == "greater", ">", "<"), val2)
        #print(col) #debug
        #print(means_list[[col]]) #debug
        #print(means_list) #debug
        
        # Check normality
        normal1 <- shapiro.test(df[[col]][df[[group]] == val1])$p.value >= 0.05
        normal2 <- shapiro.test(df[[col]][df[[group]] == val2])$p.value >= 0.05
        
        #Perform test based on normality
        if (!normal1 | !normal2) {
          #Wilcoxon for non-normal distribution
          p_values[col] <- wilcox.test(df[[col]][df[[group]] == val1], df[[col]][df[[group]] == val2], alternative = alt)$p.value
        } else {
          #t-test for normal distribution
          #Should implement homoscedasticity test here
          p_values[col] <- t.test(df[[col]][df[[group]] == val1], df[[col]][df[[group]] == val2], alternative = alt)$p.value
        } 
        
      } else {
        means_list[[col]] <- NA
        p_values[col] <- NA
      }
    }
    
    #Correct p-values if wanted. It corrects all p_value at the same time. 
    corrected_p_values <- p.adjust(p_values, method = correc_method)
    #Create output with significance and alternative hypothesis stated.
    if (word == "yes") {
      sig_table_word <- sapply(seq_along(corrected_p_values), function(i) {
        p <- corrected_p_values[i]
        col <- column_of_interest[i]

        if (is.na(p)) {
          return(NA)
        } else if (p >= 0.05) {
          return("not significant")
        } else {
          return(paste("significant", means_list[[col]]))
        }
      })
      sig_table_word <- setNames(sig_table_word, column_of_interest)
      results_list[[group]] <- list("p_values" = corrected_p_values, "p_words" = sig_table_word)
    } else {
      results_list[[group]] <- corrected_p_values
    }
    
  } else {
    #run the function in the more complicated way with a further level of grouping
    unique_group2 <- unique(df[[group2]])
    
    for (val in unique_group2) {
      #print(val) #debug
      #filter data for only one unique value of the II grouping method
      df2 <- df[df[[group2]] == val, ]

      #initialise p_values means_list for each val
      p_values <- numeric(length(column_of_interest))
      names(p_values) <- column_of_interest
      means_list <- list()
      
      for (col in column_of_interest) {
        #skip the column if it has all equal values. Wilcoxon cannot be computed otherwise
        if (length(unique(df2[[col]][df2[[group]] == val1])) > 1 & length(unique(df2[[col]][df2[[group]] == val2])) > 1) {

          #compute alternative hypotheses
          mean1 <- mean(df2[[col]][df2[[group]] == val1])
          mean2 <- mean(df2[[col]][df2[[group]] == val2])
          
          #check is both median are actual numbers. If any if NA then there are no row matching the grouping of interest and the test cannot be computed
          if (!is.na(mean1) && !is.na(mean2)) {
            alt <- if ((mean1 - mean2) >= 0) "greater" else "less"
            #add hypothesis to means_list
            means_list[[col]] <- sprintf("%s%s%s", val1, ifelse(alt == "greater", ">", "<"), val2)
            #print(means_list[[val]][[col]]) #debug
            #print(means_list[[val]]) #debug
            
            #Check normality
            normal1 <- shapiro.test(df2[[col]][df2[[group]] == val1])$p.value >= 0.05
            normal2 <- shapiro.test(df2[[col]][df2[[group]] == val2])$p.value >= 0.05
            
            if (!normal1 | !normal2) {
              #Wilcoxon for non-normal distribution
              p_values[col] <- wilcox.test(df2[[col]][df2[[group]] == val1], df2[[col]][df2[[group]] == val2], alternative = alt)$p.value
            } else {
              #t-test for normal distribution
              p_values[col] <- t.test(df2[[col]][df2[[group]] == val1], df2[[col]][df2[[group]] == val2], alternative = alt)$p.value
            } 
          } else {
            means_list[[col]] <- NA
            p_values[col] <- NA
          }
        } else {
          means_list[[col]] <- NA
          p_values[col] <- NA
        }
      }
    corrected_p_values <- p.adjust(p_values, method = correc_method)
    #print(means_list) #debug
    #Create output with significance and alternative hypothesis stated.
    if (word == "yes") {
      sig_table_word <- sapply(seq_along(corrected_p_values), function(i) {
        p <- corrected_p_values[i]
        #print(p)
        col <- column_of_interest[i]

        if (is.na(p)) {
          return(NA)
        } else if (p >= 0.05) {
          return("not significant")
        } else {
          return(paste("significant", means_list[[col]]))
        }
      })
      sig_table_word <- setNames(sig_table_word, column_of_interest)
      results_list[[val]] <- list("p_values" = corrected_p_values, "p_words" = sig_table_word)
    } else {
      results_list[[val]] <- corrected_p_values
    }
    }
  }

  return(results_list)
}

##apply sig_diff_net_metrics to the network of interest in the extended format
anal_sig_metrics <- function(df, int_groups, correct_method = "none", word = "no") {
  
  if (length(int_groups) > 1) {
    expanded_int_groups <- permutations(length(int_groups), 2, v = int_groups, set = F)
  }
  
  #initialise data_frame results
  results_df <- data.frame()
  results_word_df <- data.frame()
  
  for (group in int_groups) {
    #print(sprintf("Working on %s", group)) #debug
    group_result <- sig_diff_net_metrics(df, group, correc_method = correct_method, word = word)
    group_df <- data.frame(p_value = unlist(group_result[[group]]$p_values))
    group_word_df <- data.frame(significance = unlist(group_result[[group]]$p_words))
    colnames(group_df) <- group
    colnames(group_word_df) <- group
    
    if (nrow(results_df) == 0) {
      results_df <- group_df
      results_word_df <- group_word_df
    } else {
      results_df <- cbind(results_df, group_df)
      results_word_df <- cbind(results_word_df, group_word_df)
    }
  }
  
  if (exists("expanded_int_groups")) {
    for (row in 1:nrow(expanded_int_groups)) {
      #print(sprintf("Working on %s and %s ", expanded_int_groups[row, 1], expanded_int_groups[row, 2]))
      group_result <- sig_diff_net_metrics(df, expanded_int_groups[row, 1], group2 = expanded_int_groups[row, 2], correc_method = correct_method, word = word)
      for (i in seq_along(group_result)) {
        df_partial <- data.frame(p_value = unlist(group_result[[i]]$p_values))
        df_word_partial <- data.frame(significance = unlist(group_result[[i]]$p_words))
        new_col_name <- paste(names(group_result)[i], expanded_int_groups[row, 1], sep = "_")
        colnames(df_partial) <- new_col_name
        colnames(df_word_partial) <- new_col_name
        results_df <- cbind(results_df, df_partial)
        results_word_df <- cbind(results_word_df, df_word_partial)
      }
    }
  }
  
  return(list("results_df" = results_df, "results_word_df" = results_word_df))
}

##write results of anal_sig_metrics specifying the name
write_results_table <- function(df, dir_path, name) {
  #create names
  file_name_num <- paste(name,".tsv", sep="")
  file_name_word <- paste(name,"_word.tsv", sep="")
  
  #write results with numbers
  write.table(df$results_df, file=paste(dir_path, file_name_num, sep="/"), quote = F, sep = "\t")
  
  #write results with words
  write.table(df$results_word_df, file=paste(dir_path, file_name_word, sep="/"), quote = F, sep = "\t")
}

##complete function that sums all the previous three
interesting_groups <- c("force", "trait", "multi", "anage")
network_analysis_longevity <- function(df, int_groups, correct_method = "none", word = "yes", dir_path) {
  results_name <- deparse(substitute(df))
  reformat_table_net_analyses(df)
  results <- anal_sig_metrics(expanded_df, int_groups, correct_method = correct_method, word = word)
  write_results_table(results, dir_path, results_name)
}

network_analysis_longevity(notext_red, interesting_groups, dir_path = '../07_selection/02_codeml/03_results/08_weight_control/string/')
#This function is correct until we use it for trait, multi, and force significance. The expanded_df version cannot be used for Anage, since there is no meaning in using duplicated rows (unless we intersecate it with trait, force, or multi). For this reason, the pure "anage" column is computed indipendently

anage_notext_significance <- sig_diff_net_metrics(notext_red, "anage", correc_method = "none", word = "yes")
anage_notext_pvalue <- as.data.frame(anage_notext_significance$anage$p_values)
anage_notext_word <- as.data.frame(anage_notext_significance$anage$p_words)
write_results_table(anage_notext_pvalue, '../07_selection/02_codeml/03_results/08_weight_control/string/', "anage_notext_p")
write_results_table(anage_notext_word, '../07_selection/02_codeml/03_results/08_weight_control/string/', "anage_notext_w")

#extract most interesting genes
quantile(notext_complete$Degree, 0.9) #4
write.table(x = notext_complete %>% filter(Degree > quantile(notext_complete$Degree, 0.9)) %>% select(c(name, symbol, description, trait, force, Degree)), file = '../07_selection/02_codeml/03_results/08_weight_control/interesting_genes/text_degree.tsv', sep = "\t", quote = F, row.names = F)
quantile(notext_complete$Stress, 0.9) #2313.6
write.table(x = notext_complete %>% filter(Stress > quantile(notext_complete$Stress, 0.9)) %>% select(c(name, symbol, description, trait, force, Stress)), file = '../07_selection/02_codeml/03_results/08_weight_control/interesting_genes/text_stress.tsv', sep = "\t", quote = F, row.names = F)
quantile(notext_complete$ClusteringCoefficient, 0.9) #1
write.table(x = notext_complete %>% filter(ClusteringCoefficient >= quantile(notext_complete$ClusteringCoefficient, 0.9)) %>% select(c(name, symbol, description, trait, force, ClusteringCoefficient)), file = '../07_selection/02_codeml/03_results/08_weight_control/interesting_genes/text_ClusteringCoefficient.tsv', sep = "\t", quote = F, row.names = F)
quantile(notext_complete$Radiality, 0.9) #1. Not extracted