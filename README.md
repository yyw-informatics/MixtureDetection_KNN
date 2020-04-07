# Iterative Neighborhood detection to classify mixtures from Whole genome sequencing (WGS)

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

- Overview:

<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/Process.png" width="700" />
</p>

- The Iterative KNN has 5 steps:

  1. Mix: Select samples from each cluster and mix these samples to create pseudo mixtures.
  
<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/InitialData.png" width="400" />
</p>

  2. Merge: Merge pseudo mixtures with original data
  
<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/Embedded.png" width="400" />
</p>

  3. Calculate: After a KNN, for each sample, calculate q, the adjusted praction of neighbors that were pseudo mixtures (n_pseduo_neighbors).
<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/K.png" width="400" />
</p>

  4. Remove: Automatically thresolding q using the bimodal distributions, and remove samples exceeding the thresold from the next round of KNN. 
  
  5. Repeat: iterate i to iv until no samples exceed the cutoff.


  
- Below is a simple illustration of the iterative KNN method:
A total of 19/20 samples mixing at various ratios of two strains were detected correctly.

<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_1_scatterplot-1.png" width="500" />
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_2_scatterplot-1.png" width="500" /> 
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_3_scatterplot-1.png" width="500" />
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_4_scatterplot-1.png" width="500" /> 
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/figuresKNN_1_round_5_scatterplot-1.png" width="500" />
</p>

- Below is a barplot showing the strain abundances within the first ten samples of three-strains mixtures
<p float="left">
<img src="https://github.com/YYW-UMN/MixtureDetection_KNN/blob/master/Abundances.png" width="600" />
</p>


