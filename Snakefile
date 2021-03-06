configfile: "config.json"

rule index_genome:
    input:
        fasta = config["GENOME_FA"],
        gtf = config["GENOME_GTF"]
    output:
        config["GENOME_INDEX_DIR"]
    params:
        overhang = "99"
    shell:
        "mkdir -p {output};"
        "STAR --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {input.fasta} --sjdbGTFfile {input.gtf} --sjdbOverhang {params.overhang}"

rule align:
    input:
        reads = config["INDIR"] + "{sample}",
        genome_index = config["GENOME_INDEX_DIR"]
    output:
        config["BAMDIR"] + "{sample}.bam"
    params:
        outdir = "{sample}",
        cores = "4"

    shell:
        "mkdir -p STAR/{params.outdir}/;"
        "STAR --genomeDir {input.genome_index} --readFilesIn `ls {input.reads}/*_1.fastq.gz | paste -d ',' -s -` `ls {input.reads}/*_2.fastq.gz | paste -d ',' -s -` --outFileNamePrefix STAR/{params.outdir}/ --readFilesCommand zcat --genomeLoad NoSharedMemory --clip3pAdapterSeq AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT,AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT --outSAMtype BAM SortedByCoordinate --outFilterMultimapNmax 3 --outSAMstrandField intronMotif --runThreadN {params.cores};"
	"mv `ls STAR/{params.outdir}/*.bam` {output};"

rule count:
    input:
        gtf = config["GENOME_GTF"],
        bams = expand(config["BAMDIR"] + "{bamsample}.bam", bamsample = config["CLASS1"] + config["CLASS2"])
    output:
        "counts/counts.txt"
    shell:
        "featureCounts -R -B -p -T 8 -a {input.gtf} -o {output} {input.bams}"

rule DESeq_data:
    input:
        "counts/counts.txt"
    output:
        "DEresults/DESeq2.RData"
    script:
        "Scripts/DESeq_object.R"

rule plot_PCA:
    input:
        "DEresults/DESeq2.RData"
    output:
        "DEresults/PCA_plot.tiff"
    shell:
        "Rscript Scripts/PCA.R"

rule DESeq_DE:
    input:
        "DEresults/DESeq2.RData"
    output:
        "DEresults/DESeq_results.xlsx",
        "DEresults/signif_DESeq_results.xlsx",
        "DEresults/MA_plot.tiff",
        "DEresults/DESEq_results.RData"
    script:
        "Scripts/DESeq_DE.R"
