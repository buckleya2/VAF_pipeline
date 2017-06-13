#!/bin/bash

export ID="INS_ID"
export SHORT_ID="INS_SHORT_ID"
export UUID="INS_UUID"

path="/nrnb/users/abuckley/GDC/somatic/"

# source config file that specifies global variables
source ${path}/scripts/clean/VAF.config
source activate py27

# make directory for sample output files
mkdir -p ${path}/VAF/${ID}

# download somatic BAM from GDC
echo "Download BAM"
${scripts_dir}/VAF_pipeline/GDC.legacy.BAM.sh

# select germline variants of interest, generate bed file
echo "Select germline varaints"
${scripts_dir}/VAF_pipeline/select.germline.variants.sh

# select regions of interest from somatic BAM, call variants with samtools
echo "Call somatic variants"
${scripts_dir}/VAF_pipeline/mpileup.sh

# merge germline and somatic variant data
echo "Merge germline and somatic"
python ${scripts_dir}/VAF_pipeline/merge.germ.som.py ${path}/VAF/${ID}/${ID}.somatic.vcf  ${path}/VAF/${ID}/${ID}.germline.var  ${path}/VAF/${ID}/${ID}.merged


# remove somatic BAM file
 rm ${path}/VAF/${ID}.bam
