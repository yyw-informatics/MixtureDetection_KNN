# Iterative K Nearest Neighbor (KNN) to detect mixtures from Whole genome sequencing (WGS)

## Objective:
Identify WGS samples infected with multiple strains of Mycobacterium bovis (M. bovis) or other slow evolving pathogens

## Motivation:
Phylogenetic trees shows the overall ancestral relations between a set of samples. However, the limitation of a tree structure is that each child node can only have one parent node. 

Mixture samples, however, may have the SNP pattern of multiple ancestral strains. Identify mixture samples before constructing a phylognetic tree, and split these amples by each of their contributing strains will improve inference of who-infected-whom. 

Especially for individuals infected with different host species, identifying mixing patterns will help to infer the directionality of transmission.

## Method:
- Original data: 
  - Genotypes from SNP calling of WGS data
  - Minor allele read count for each SNP & sample
- Input data: Principle components calculated from the allele frequencies or minor allele read count matrix
- The Iterative KNN has 5 steps:
  1. Mix: Select samples from each cluster and mix these samples to create pseudo mixtures.
  2. Merge: Mergen pseudo mixtures with original data
  3. Count: After a KNN, for each sample, count the neighbors that were pseudo mixtures (n_pseduo_neighbors).
  4. Remove: Look at the ratio of n_pseduo_neighbors/n_all_neighbors, if it exceeds a cutoff, for example 60%, remove this sample from the next round of KNN. 
  5. Repeat: iterate i to iv until no samples exceed the cutoff.
  
Below is an example of the iterative KNN method detected 19/20 samples mixing at various ratios of two strains.

<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_1_scatterplot-1.png" width="270" />
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_2_scatterplot-1.png" width="270" /> 
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_3_scatterplot-1.png" width="270" />
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_4_scatterplot-1.png" width="270" /> 
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_5_scatterplot-1.png" width="270" />
</p>

Below is a barplot showing the strain composition within each sample
<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/Demix_results.png" width="1000" />
</p>


