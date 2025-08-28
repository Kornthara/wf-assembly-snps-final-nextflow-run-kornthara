# Fix for Missing Required Parameters Error

## 🚨 Your Error:
```
ERROR ~ Validation of pipeline parameters failed!
* Missing required parameter(s): input, outdir
```

## ✅ The Fix:

You need to provide both `--input` and `--outdir` parameters when running the pipeline.

### ❌ What you probably ran (incorrect):
```bash
nextflow run .
```
or
```bash
nextflow run . -profile local_12core
```

### ✅ What you need to run (correct):
```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 📋 Required Parameters:

1. **`--input`**: Path to your samplesheet CSV file
2. **`--outdir`**: Directory where results will be saved

## 🚀 Complete Command Examples:

### Basic run:
```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

### With resource limits for your 12-core system:
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core
```

### Resume a failed run:
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## 🔍 Check Your Setup:

Your current samplesheet looks good:
```csv
sample,assembly
sample1,test_assemblies/sample1.fasta
sample2,test_assemblies/sample2.fasta
```

## 📁 Expected Output Structure:

After running successfully, you'll get:
```
results/
├── parsnp/                    # Core genome alignment
├── harvesttools/              # Format conversions
├── snpdists/                  # SNP distance matrices
├── snpsites/                  # SNP sites
├── multiqc/                   # Quality report
└── pipeline_info/             # Execution info
```

## 🎯 Key Points:

1. **Always provide `--input` and `--outdir`** - they are mandatory
2. **Use the `local_12core` profile** for your 12-core system
3. **The samplesheet must be a CSV file**, not a directory path
4. **Use absolute paths** or run from the pipeline directory

That's it! Just add the missing parameters and your pipeline will run successfully.