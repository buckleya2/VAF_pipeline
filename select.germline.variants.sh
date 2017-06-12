#!/bin/bash

# select variants of interest for sample
# generate bed file to specify regions of interest in somatic BAM

awk -v OFS='\t' -v id=${SHORT_ID} '{split($1, a, "-"); if( a[3] == id ) {print $0}}' ${var_file} | python ${scripts_dir}/variant_parsing/fix.indel.alt.inline.py > ${path}/VAF/${ID}/${ID}.germline.var
echo -e "add ${padd_amt} bp padding"
awk -v OFS='\t' -v padd=${padd_amt} '{print $2,$3-padd, $3+padd }' ${path}/VAF/${ID}/${ID}.germline.var > ${path}/VAF/${ID}/${ID}.germline.bed
