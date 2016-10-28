suppressWarnings(suppressMessages(library(stringr)))
suppressWarnings(suppressMessages(library(DESeq2)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(matrixStats)))

# Function for PCA plots, modified from the one in DESeq2 package.
myPCA <- function (x, intgroup = "condition", ntop = 500, returnData = FALSE)
{
  rv <- rowVars(assay(x))
  select <- order(rv, decreasing = TRUE)[seq_len(min(ntop,
                                                     length(rv)))]
  pca <- prcomp(t(assay(x)[select, ]))
  percentVar <- pca$sdev^2/sum(pca$sdev^2)
  if (!all(intgroup %in% names(colData(x)))) {
    stop("the argument 'intgroup' should specify columns of colData(dds)")
  }
  intgroup.df <- as.data.frame(colData(x)[, intgroup, drop = FALSE])
  group <- apply(intgroup.df, 1, paste, collapse = " : ")
  group <- factor(group)
  d <- data.frame(PC1 = pca$x[, 1], PC2 = pca$x[, 2], Genotype = group,
                  intgroup.df, names = colnames(x))
  if (returnData) {
    attr(d, "percentVar") <- percentVar[1:2]
    return(d)
  }
  ggplot(data = d, aes_string(x = "PC1", y = "PC2", color = "Genotype")) + geom_point(size = 5) + theme_bw() + theme(text = element_text(size = 25)) + xlab(paste0("PC1: ", round(percentVar[1] * 100), "% variance")) + ylab(paste0("PC2: ", round(percentVar[2] * 100), "% variance"))
}

# Load DESeq2 data
load('DEresults/DESeq2.RData')

# Plotting
trans.deseq <- varianceStabilizingTransformation(deseq)
tiff(file = 'DEresults/PCA_plot.tiff')
myPCA(trans.deseq, intgroup = 'class')
suppressMessages(dev.off())
