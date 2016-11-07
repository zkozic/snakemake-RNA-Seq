suppressWarnings(suppressMessages(library(stringr)))
suppressWarnings(suppressMessages(library(DESeq2)))
suppressWarnings(suppressMessages(library(ggplot2)))

# Read arguments from snakemake
counts = attr(snakemake, 'input')[[1]]
c1 = attr(snakemake, 'config')$CLASS1
c2 = attr(snakemake, 'config')$CLASS2

# Read count table
count.table <- read.table(counts, sep = '\t', as.is = T, header = T)

# Get column indices for sample counts
sample.index <- sapply(c(c1, c2), function(x)which(str_detect(colnames(count.table), x)))

# Refined count table
count.table <- count.table[, sample.index]
rownames(count.table) <- count.table$Geneid
colnames(count.table) <- names(sample.index)

# Create DESeq object
sample.class <- as.data.frame(c(rep('class1', length(c1)), rep('class2', length(c2))))
colnames(sample.class) <- 'class'
rownames(sample.class) <- names(sample.index)
deseq <- DESeqDataSetFromMatrix(countData = count.table, colData = sample.class, design = ~ class)

# Save deseq object and count table
save(deseq, count.table, c1, c2, file = 'DEresults/DESeq2.RData')
