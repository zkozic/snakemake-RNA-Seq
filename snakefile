SAMPLES = ["P1hom", "P2hom", "T1hom", "T1het"]
INDIR = "raw_reads/"
BAMDIR = "test/"

rule align:
    input:
        INDIR + "{sample}"
    output:
        BAMDIR + "{sample}.txt" # replace .txt with .bam
    shell:
        # placeholder command until I get STAR on my desktop or Python 3.5 on the server
        # this command will call STAR and generate bam file
        # also has to rename and move the bam file, as well as all the log files
        "echo `ls {input}/*_1.sanfastq.gz | paste -d ',' -s -` `ls {input}/*_2.sanfastq.gz | paste -d ',' -s -`> {output}"

rule count:
    input:
        expand(BAMDIR + "{sample}.txt", sample = SAMPLES)
    output:
        "counts/count_table.txt" # replace .txt with .bam
    shell:
        # placeholder command until I get featureCounts on my desktop or Python 3.5 on the server
        # command will run featureCounts to generate count table
        "echo {input} > {output}"
