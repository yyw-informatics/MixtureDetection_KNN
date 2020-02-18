
tsneKNN <- function(x, y, is_suspect, iter){
  n_samples <- nrow(x)
  n_snps <- ncol(x)
  n_suspects <- length(which(is_suspect == 'TRUE'))
  n_start <- n_samples
  n_end <- n_samples - n_suspects
  
  bg <- rep('black', n_samples)
  bg[is_suspect] <- 'orange'
  bg[rowData(x)$is_pseudo] <- 'blue'
  pch <- c(rep(19, n_samples))
  pch[is_suspect] <- 15
  pch[rowData(x)$is_pseudo] <- 17
  
  plot(y, pch = pch, col = bg, cex = 1.5,
       main = sprintf('Iteration: %d, Suspects found: %d, \nStarted with: %d, Ended with: %d', iter, n_suspects, n_start, n_end))
  legend('bottomleft',legend = c('pseudo mixtures','detected mixtures'), pch = c(17, 15), cex = 2, col = c("blue", "orange"))
}
