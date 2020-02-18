library(Matrix)
library(dplyr)
library(irlba)
library(Rtsne)
library(ggplot2)
library(scatterpie)
library(gplots)
library(SummarizedExperiment)

simulateAltReadCount <- function(n_snps, n_strain, n_samples, n_mixture, min_depth, max_depth, n_max_mixture, n_pc, beta, min_alt, max_alt, seed){
      set.seed(seed)
      # simulate ancestor
      alt_ratio <- runif(n_strain, min = min_alt, max = max_alt)
      SimulateAncestorStrains <- function(n_snps,n_strain,alt_ratio) {
        anc <- matrix(0,nrow = n_strain,ncol = n_snps) 
        for (s in (1:n_strain)){
          anc[s,] <- sample(0:1,size=n_snps,replace = TRUE, prob = c(1-alt_ratio[s],alt_ratio[s]))
        }
        if (length(which(colSums(anc) == 0) > 0)){ 
          fill.sites <- which(colSums(anc) == 0)
          fill.rows <- sample(1:n_strain,sample(1:(n_strain-1),1))
          anc[fill.rows,fill.sites] <- 1
        }
        return(anc) 
      }
      anc <- SimulateAncestorStrains(n_snps, n_strain, alt_ratio)
      ### Generate a sample ~ strain assignment matrix
      A <- sparseMatrix(
        i = 1:n_samples, 
        j = sample(1:n_strain, n_samples, replace = TRUE), 
        dims = c(n_samples, n_strain)
      )
      A_noise <- A + runif(prod(dim(A)), min = 0, max = beta) 
      A_noise <- Diagonal(x =  1 / Matrix::rowSums(A_noise)) %*% A_noise
      ### Randomly pick pairs of sample for mixing and randonly set their mixing ratio
      # A_mix is a sample ~ strain matrix represeting the mixture ratio of each strain
      A_mix <- do.call('rbind', lapply(1:n_mixture, function(h){
        p <- runif(n_strain)
        off <- sample(n_strain, n_strain - n_max_mixture)
        p[off] <- 0
        p <- p / sum(p)
        p
      }))
      A_merge_noise <- rbind(A_noise, A_mix)
      A_merge <- rbind(A, A_mix)
      ### Simulating sequence depth for input samples and mixture samples
      D <- sample(min_depth:max_depth, (n_samples + n_mixture) * n_snps, replace = TRUE) %>%
        matrix(nrow = n_samples + n_mixture, ncol = n_snps)
      #print(dim(D))
      ### Generate alt read count from allele frequency and coverage
      GT <- A_merge_noise %*% anc # matrix multiplication: GT is allele frequency matrix: a sample ~ SNP 
      Alt_count <- round(GT * D) # multiply element wise 
      results <- SummarizedExperiment(assays = list(count = Alt_count, depth = D))
      rowData(results)$mixture <- A_merge
      return(results)
}
