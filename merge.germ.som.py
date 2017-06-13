'''
merge germline and somatic read information
final file has number of ref, alt reads in somatic and germline for variants of interest
'''

import pandas as pd
from sys import argv

script, som, germ, output=argv 

# read in germline and somatic variant files
somatic=pd.read_csv(som, sep='\t')
germline=pd.read_csv(germ, sep='\t' , header=None, names=['CHR','POS','REF','ALT','INFO'])

# parse germline INFO into separate columns
germline['ZYGOSITY']=germline.INFO.apply(lambda x: str(x).split(":")[0])
germline['REF_READS_GERM']=germline.INFO.apply(lambda x: str(x).split(":")[1])
germline['ALT_READS_GERM']=germline.INFO.apply(lambda x: str(x).split(":")[2])
germline.drop('INFO', axis=1, inplace=True)

# convert chromsome to string for merging
somatic.CHR=somatic.CHR.astype('str')
germline.CHR=germline.CHR.astype('str')

# merge keeping all germline variants
FIN=pd.merge(germline, somatic, on=['CHR','POS','REF','ALT'], how="left")

FIN.to_csv(output, sep='\t', index=False)

# for germline variants that aren't present in somatci VCF, get somatic read depth at those loci

fail=FIN[pd.isnull(FIN.ALT_COUNT)][['CHR','POS', 'REF_READS_GERM','ALT_READS_GERM']]

fail_depth=pd.merge(somatic, fail, on=['CHR','POS'])
fail_depth=fail_depth[['CHR','POS','REF_READS_GERM','ALT_READS_GERM','REF_COUNT','ALT_COUNT']]
fail_depth.drop_duplicates(inplace=True)

fail_depth.to_csv(output + ".fail", sep='\t', index=False)
