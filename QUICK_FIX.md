# 🚨 QUICK FIX - Missing Parameters Error

## Your Error:
```
ERROR ~ Validation of pipeline parameters failed!
* Missing required parameter(s): input, outdir
```

## ⚡ **INSTANT FIX** (copy/paste this):

```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 🎯 What Was Wrong:
You ran the pipeline without the required `--input` and `--outdir` parameters.

## ✅ What This Command Does:
- `--input samplesheet.csv` → Tells pipeline what samples to process
- `--outdir results` → Tells pipeline where to save results  
- `-profile local_12core` → Uses your 12-core system optimally

## 📊 Expected Output:
```
executor >  local (5)
[XX/XXXXXX] process > ASSEMBLY_SNPS:PARSNP           [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:HARVESTTOOLS     [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:SNPDISTS         [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:SNPSITES         [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:MULTIQC          [100%] 1 of 1 ✔

Completed at: [timestamp]
Duration    : ~5-15 minutes
Succeeded   : 5
```

That's it! Just add the missing parameters and run.