simulateAncestorStrains <- function(n_snps,n_strain,alt_ratio) {
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
