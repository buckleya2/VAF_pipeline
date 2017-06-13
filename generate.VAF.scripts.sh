#!/bin/bash

# script to generate VAF pipeline scripts
# one script per sample

path="/nrnb/users/abuckley/GDC/somatic/scripts/clean/"
template="/cellar/users/abuckley/github_scripts/VAF_pipeline/VAF.pipeline.sh"
samp_file="${path}/somatic.germline.merge"

count=0
while read short_id id uuid
do
echo ${id}
sed -e 's/INS_SHORT_ID/'${short_id}'/g' -e 's/INS_ID/'${id}'/g' -e 's/INS_UUID/'${uuid}'/g' ${template} > /nrnb/users/abuckley/GDC/somatic/scripts/VAF_array/${count}.VAF.sh
count=$((count+1))
done <${samp_file}
