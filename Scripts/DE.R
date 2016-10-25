suppressWarnings(library(stringr))
suppressWarnings(library(DESeq2))
suppressWarnings(library(ggplot2))

counts = attr(snakemake, 'input')[[1]]
c1 = attr(snakemake, 'config')$CLASS1
c2 = attr(snakemake, 'config')$CLASS2

save(counts, c1, c2, file = 'DEresults/DESeq2.RData')
