#!/bin/bash

# subset somatic BAM to regions of interest (location of germline variants +/- specified number of bp)
# generate VCF using samtools mpileup
# parse VCF to only variant sites, smallest indel notation, ref and alt reads

positions="${path}/VAF/${ID}/${ID}.germline.bed"
bam="${path}/VAF/${ID}/${ID}.bam"

${samtools} view -hu ${bam} -L ${positions} |${samtools} mpileup -uv - -t INFO/AD -f ${ref} |  python ${scripts_dir}/parse.mpileup.py > ${path}/VAF/${ID}/${ID}.somatic.vcf
