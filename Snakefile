configfile: "config.json"

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
        bams = expand(config["BAMDIR"] + "{bamsample}.bam", bamsample = config["SAMPLES"])
    output:
        "counts/counts.txt"
    shell:
        "featureCounts -R -a {input.gtf} -o {output} {input.bams}"
