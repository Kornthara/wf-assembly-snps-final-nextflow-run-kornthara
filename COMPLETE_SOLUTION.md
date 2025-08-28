# Complete Solution for Missing Parameters Error

## 🚨 Your Error:
```
ERROR ~ Validation of pipeline parameters failed!
* Missing required parameter(s): input, outdir
```

## 🎯 Root Cause:
You ran the pipeline without providing the mandatory `--input` and `--outdir` parameters.

## ✅ **IMMEDIATE FIX** (Copy and paste this):

```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 📋 What Each Parameter Does:

- **`--input samplesheet.csv`**: Tells the pipeline where your sample information is
- **`--outdir results`**: Tells the pipeline where to save the results
- **`-profile local_12core`**: Uses the optimized configuration for your 12-core system

## 🔍 Your Current Setup Status:

✅ **Pipeline**: Ready (`nf-core-assemblysnps`)  
✅ **Samplesheet**: Ready (`samplesheet.csv`)  
✅ **Test data**: Ready (`test_assemblies/`)  
✅ **Configuration**: Ready (`local_12core` profile)  

Your samplesheet contains:
```csv
sample,assembly
sample1,test_assemblies/sample1.fasta
sample2,test_assemblies/sample2.fasta
```

## 🚀 Run Options:

### Option 1: Quick Test Run
```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

### Option 2: With Resource Limits
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core
```

### Option 3: Resume if Failed
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## 📊 Expected Results:

After successful completion, you'll see:
```
results/
├── parsnp/                    # Core genome alignment results
│   ├── parsnp_analysis.ggr    # Gingr format
│   ├── parsnp_analysis.xmfa   # Multi-FASTA alignment
│   ├── parsnp_analysis.tree   # Phylogenetic tree
│   └── parsnp_analysis.SNPs.fa.gz # SNP sequences
├── harvesttools/              # Converted alignments
├── snpdists/                  # SNP distance matrices
├── snpsites/                  # Extracted SNP sites
├── multiqc/                   # Quality control report
└── pipeline_info/             # Execution reports
```

## 🔧 Troubleshooting:

### If you get "file not found" errors:
```bash
# Make sure you're in the right directory
cd nf-core-assemblysnps
pwd
ls -la samplesheet.csv
```

### If you get permission errors:
```bash
# Check file permissions
ls -la test_assemblies/
chmod +r test_assemblies/*
```

### If you get memory errors:
```bash
# Reduce memory allocation
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 32.GB \
    --max_cpus 8 \
    -profile local_12core
```

## 🎉 Success Indicators:

You'll know it's working when you see:
```
N E X T F L O W  ~  version 24.10.5
Launching `./main.nf` [name] DSL2 - revision: 29e61374d2

executor >  local (X)
[XX/XXXXXX] process > ASSEMBLY_SNPS:PARSNP (parsnp_analysis)           [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:HARVESTTOOLS (parsnp_analysis)     [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:SNPDISTS (parsnp_analysis)         [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:SNPSITES (parsnp_analysis)         [100%] 1 of 1 ✔
[XX/XXXXXX] process > ASSEMBLY_SNPS:MULTIQC                            [100%] 1 of 1 ✔

Completed at: [timestamp]
Duration    : [time]
CPU hours   : [hours]
Succeeded   : X
```

## 🎯 **Bottom Line:**

The fix is simple - just add `--input samplesheet.csv --outdir results` to your command. These are mandatory parameters that tell the pipeline what to process and where to save results.

**Run this now:**
```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```