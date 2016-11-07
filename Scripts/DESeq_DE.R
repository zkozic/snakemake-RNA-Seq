suppressWarnings(suppressMessages(library(stringr)))
suppressWarnings(suppressMessages(library(DESeq2)))
suppressWarnings(suppressMessages(library(WriteXLS)))

# Load DESeq2 data
load('DEresults/DESeq2.RData')

# Load annotation table
#save(snakemake, 'snakemake.RData')
anntab <- read.csv(attr(snakemake, 'config')$ANNOTATION)
rownames(anntab) <- anntab[, 1]

# Run DE
suppressWarnings(suppressMessages(de <- DESeq(deseq)))
restab <- as.data.frame(results(de))
restab <- cbind(symbol = anntab[rownames(restab), 2], restab)
WriteXLS(restab, ExcelFileName = 'DEresults/DESeq_results.xlsx', row.names = T, AdjWidth = T, BoldHeaderRow = T)
filt.restab <- na.omit(restab)
filt.restab <- filt.restab[filt.restab$padj <= 0.05, ]
filt.restab <- filt.restab[order(filt.restab$padj, decreasing = F), ]
WriteXLS(filt.restab, ExcelFileName = 'DEresults/signif_DESeq_results.xlsx', row.names = T, AdjWidth = T, BoldHeaderRow = T)

# Make MA plot
tiff(file = 'DEresults/MA_plot.tiff')
plotMA(de, alpha = 0.05)
dev.off()

save(de, restab, filt.restab, file = 'DEresults/DESEq_results.RData')
