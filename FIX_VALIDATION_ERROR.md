# Fix for Pipeline Parameter Validation Error

## Error Description

```
ERROR ~ Validation of pipeline parameters failed!
* --input (/path/to/directory): is not a file, but a directory
* --input (/path/to/directory): does not match regular expression [^\S+\.csv$]
```

## Root Cause

You're trying to pass a **directory path** directly to the `--input` parameter, but the pipeline expects a **CSV samplesheet file**.

## ❌ What You Did (Incorrect)

```bash
nextflow run . --input /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
```

## ✅ What You Need to Do (Correct)

### Step 1: Create a Samplesheet from Your Directory

Use the provided script to automatically create a samplesheet:

```bash
./create_samplesheet_from_directory.sh /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
```

This will create a `samplesheet.csv` file like this:

```csv
sample,assembly
sample1,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample1.fasta
sample2,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample2.fasta
sample3,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample3.fasta
```

### Step 2: Run the Pipeline with the Samplesheet

```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## Manual Samplesheet Creation

If you prefer to create the samplesheet manually:

### 1. Check what assembly files you have:

```bash
ls -la /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/
```

### 2. Create samplesheet.csv manually:

```bash
cat > samplesheet.csv << 'EOF'
sample,assembly
sample1,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/file1.fasta
sample2,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/file2.fasta
sample3,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/file3.fasta
EOF
```

Replace `file1.fasta`, `file2.fasta`, etc. with your actual assembly filenames.

## Alternative: Use Directory Input Feature

If you're using the updated pipeline that supports directory inputs, you can create a samplesheet that references the directory:

```csv
sample,assembly
assembly_group,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
```

## Validation Rules

The pipeline validates that:

1. **--input must be a CSV file** (not a directory)
2. **CSV file must exist** and be readable
3. **CSV must have required columns**: `sample,assembly`
4. **Assembly files must exist** and be accessible

## Common File Extensions Supported

The pipeline looks for these assembly file extensions:
- `.fasta`
- `.fa` 
- `.fna`

## Complete Example

```bash
# 1. Create samplesheet from your directory
./create_samplesheet_from_directory.sh /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly

# 2. Verify the samplesheet was created correctly
cat samplesheet.csv

# 3. Run the pipeline
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core

# 4. If you need to resume a failed run
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## Troubleshooting

### If the script can't find assembly files:

```bash
# Check what files are actually in your directory
find /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly -type f -name "*"

# Look for files with different extensions
find /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly -type f \( -name "*.fasta" -o -name "*.fa" -o -name "*.fna" -o -name "*.fas" \)
```

### If you get permission errors:

```bash
# Check file permissions
ls -la /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/

# Make files readable if needed
chmod +r /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/*
```

## Summary

The key fix is: **Don't pass directories directly to --input. Always use a CSV samplesheet file.**

Use the provided script to automatically convert your directory of assemblies into a proper samplesheet, then run the pipeline with that CSV file.