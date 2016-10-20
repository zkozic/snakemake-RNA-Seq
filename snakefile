configfile: "config.json"

'''
SAMPLES = config["SAMPLES"]
INDIR = config["INDIR"]
BAMDIR = config["BAMDIR"]
'''

rule align:
    input:
        config["INDIR"] + "{sample}"
    output:
        config["BAMDIR"] + "{sample}.txt" # replace .txt with .bam
    shell:
        # placeholder command until I get STAR on my desktop or Python 3.5 on the server
        # this command will call STAR and generate bam file
        # also has to rename and move the bam file, as well as all the log files
        "echo `ls {input}/*_1.sanfastq.gz | paste -d ',' -s -` `ls {input}/*_2.sanfastq.gz | paste -d ',' -s -`> {output}"

rule count:
    input:
        expand(config["BAMDIR"] + "{sample}.txt", sample = config["SAMPLES"])
    output:
        "counts/count_table.txt" # replace .txt with .bam
    shell:
        # placeholder command until I get featureCounts on my desktop or Python 3.5 on the server
        # command will run featureCounts to generate count table
        "echo {input} > {output}"
