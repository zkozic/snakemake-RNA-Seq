# snakemake-RNA-Seq
Intended as a snakemake pipeline for general RNA-Seq analysis. Work in progress.
RNA-Seq data I am working with originates from Edinburgh Genomics sequencing facilities.
Since they preform read adapter trimming and initial QC, these steps will not be included in the pipeline at this time.

Current version is functional until and including the read counting.

Requirements:

-Python 3.3+


-snakemake
  https://bitbucket.org/snakemake/snakemake/wiki/Home


-STAR: RNA-Seq aligner
  https://github.com/alexdobin/STAR
  required in path as STAR

-featureCounts
  http://bioinf.wehi.edu.au/featureCounts/
  required in path as featureCounts
