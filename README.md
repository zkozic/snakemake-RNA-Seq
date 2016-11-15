# snakemake-RNA-Seq
Intended as a snakemake pipeline for general RNA-Seq analysis. Work in progress.
RNA-Seq data I am working with originates from Edinburgh Genomics sequencing facilities.
Since they preform read adapter trimming and initial QC, these steps will not be included in the pipeline at this time.

Current version includes differential expression analysis with DESeq2.

# Requirements:

- [Python 3.3+](https://www.python.org/)
- [snakemake](https://bitbucket.org/snakemake/snakemake/wiki/Home)
- [STAR: RNA-Seq aligner](https://github.com/alexdobin/STAR)
  - required in path as STAR
- [featureCounts](http://bioinf.wehi.edu.au/featureCounts/)
  - required in path as featureCounts
- [The R Project for Statistical Computing](https://www.r-project.org/)
  - Including packages:
    - stringr
    - DESeq2
    - ggplot2
    - matrixStats
    - WriteXLS
