generatePseudoMixture <- function(x, n_syn_mixture, n_max_mixture) {
  
  n_snps <- ncol(x)
  n_sample <- nrow(x)
  D <- assays(x)$depth
  Alt_count <- assays(x)$count 
  
  samples_to_mix <- replicate(n_syn_mixture, sample(n_sample, n_max_mixture)) 
  
  syn_alt_count <- matrix(0, nrow = n_syn_mixture, ncol = n_snps) 
  syn_depth <- matrix(0, nrow = n_syn_mixture, ncol = n_snps)   
  for (m in 1:ncol(samples_to_mix)){ 
    syn_alt_count[m,] <- Matrix::colSums(Alt_count[samples_to_mix[,m], ]) / n_max_mixture 
    syn_depth[m,] <- Matrix::colSums(D[samples_to_mix[, m],]) / n_max_mixture            
  }
  pseudo <- SummarizedExperiment(assays = list(count = syn_alt_count, depth = syn_depth))
  rowData(pseudo)$is_pseudo <- TRUE
  rowData(pseudo)$is_suspect <- FALSE
  return(pseudo)
} # 
