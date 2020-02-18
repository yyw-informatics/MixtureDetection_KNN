findSuspectsKNN <- function(
  x, 
  n_syn_mixture, 
  n_max_mixture, 
  knn_k, 
  knn_threshold,
  n_pc,
  iter
){

  n_samples <- nrow(x)
  n_snps <- ncol(x)
  
  # normalize, scale and run pca, tsne and KNN to find suspects  
  r <- scale(log(10000 * assays(x)$count / Matrix::rowSums(assays(x)$depth) + 1)) 
  #r <- as.matrix(assays(x)$count / assays(x)$depth)             
  #r[is.nan(r)] <- 0
  #r <- scale(r)
  #r <- scale(Normalize(assays(x)$count/(assays(x)$depth+0.01)))
  
  u <- irlba(r, nu = n_pc, nv = 1, work = 20, maxit = 2000)$u # u = sample ~ n_pc
  knn <- knn.index(u, k = knn_k) 
  KNN <- sparseMatrix(
    i = rep(1:n_samples, knn_k), 
    j = c(knn), 
    dims = c(n_samples, n_samples)
  )
  # count pseudo neighbors for each row of input data
  n_pseudo_neighbor <- Matrix::rowSums(KNN[, rowData(x)$is_pseudo])
  is_suspect <- n_pseudo_neighbor > knn_threshold & !rowData(x)$is_pseudo 
  if (n_samples < 100) {
    y <- Rtsne(u, check_duplicates = FALSE, perplexity = 20)$Y
  } else {
    y <- Rtsne(u, check_duplicates = FALSE)$Y
  }
  tsneKNN(x, y, is_suspect, iter)
  is_suspect
} 
