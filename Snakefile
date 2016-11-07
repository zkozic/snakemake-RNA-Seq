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
        cores = "16"

    shell:
        "mkdir -p STAR/{params.outdir}/;"
        "STAR --genomeDir {input.genome_index} --readFilesIn `ls {input.reads}/*_1.sanfastq.gz | paste -d ',' -s -` `ls {input.reads}/*_2.sanfastq.gz | paste -d ',' -s -` --outFileNamePrefix STAR/{params.outdir}/ --readFilesCommand zcat --genomeLoad NoSharedMemory --outSAMtype BAM SortedByCoordinate --outFilterMultimapNmax 3 --outSAMstrandField intronMotif --runThreadN {params.cores};"
        "mv `ls STAR/{params.outdir}/*.bam` {output};"

rule count:
    input:
        gtf = config["GENOME_GTF"],
        bams = expand(config["BAMDIR"] + "{bamsample}.bam", bamsample = config["CLASS1"] + config["CLASS2"])
    output:
        "counts/counts.txt"
    shell:
        "featureCounts -R -a {input.gtf} -o {output} {input.bams}"

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
