iterativeKNN <- function(
  x, # input data matrix
  n_syn_mixture = 50,  # number pseudo mixture samples generated per iteration
  n_max_mixture = 2, # number of original samples used to generate pseudo mixture sample,
  knn_k = 10,  # k for KNN
  knn_threshold = 5,  # KNN cutoff
  n_pc = 5,
  try = 1
){
  
  n_original <- nrow(x)
  n_snps <- ncol(x)
  
  rowData(x) <- NULL
  colnames(x) <- NULL
  
  invalid_assays <- !names(assays(x)) %in% c('depth', 'count')
  if (any(invalid_assays)){
    for (i in names(assays(x))[invalid_assays]){
      cat(sprintf('removing invalid assay %s\n', i))
      assays(x)[[i]] <- NULL
    }
  }

  rowData(x)$is_pseudo <- FALSE
  rowData(x)$is_suspect <- FALSE
  x.copy <- x
  
  iter <- 1
  while (iter < 10){
    
    num_suspect <- sum(rowData(x)$is_suspect)
    
    cat(paste0('KNN run: ',iter,'\n'))
    
    # generate pseudo mixture
    pseudo <- generatePseudoMixture(
      x[!rowData(x)$is_suspect], 
      n_syn_mixture, 
      n_max_mixture 
    )
    colnames(pseudo) <- colnames(x)
    # combine pseudo data with real data
    x <- rbind(x, pseudo)
    is_suspect <- findSuspectsKNN(
      x, 
      n_syn_mixture, 
      n_max_mixture,
      knn_k, 
      knn_threshold,
      n_pc,
      iter
    )
    rowData(x)$is_suspect <- is_suspect | rowData(x)$is_suspect
    x <- x[!rowData(x)$is_pseudo]
    x <- x[!rowData(x)$is_suspect]
    iter <- iter + 1
    cat(paste0(length(which(is_suspect == TRUE))))
  }
  mixtures <- setdiff(rownames(x.copy),rownames(x)) 
  rowData(x.copy)$is_suspect <- FALSE
  rowData(x.copy)$is_suspect[match(mixtures, rownames(x.copy))] <- TRUE
  
  r <- as.matrix(assays(x.copy)$count / assays(x.copy)$depth)
  r[is.nan(r)] <- 0
  u <- irlba(r, nu = n_pc, nv = 1, work = 1 + 20 )$u   
  n_samples <- nrow(x.copy)
  n_snps <- ncol(x.copy)
  if (n_samples < 100) {
    y.final <- Rtsne(u, check_duplicates = FALSE, perplexity = 20)$Y
  } else {
    y.final <- Rtsne(u, check_duplicates = FALSE)$Y
  }
  is_suspect <- rowData(x.copy)$is_suspect
  n_suspects <- length(which(is_suspect == TRUE))
  bg <- rep('black', n_samples)
  bg[is_suspect] <- 'orange'
  pch <- c(rep(19, n_samples))
  pch[is_suspect] <- 15
  plot(y, pch = pch, col = bg, cex = 1.5,
       main = sprintf('%d iterations completed: %d suspects found.', iter, n_suspects))
  legend('bottomleft',legend = c('detected mixtures'), pch = 15, cex = 0.75, col = "orange")
  return(x.copy)
} 
 