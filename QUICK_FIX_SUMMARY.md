# 🚨 QUICK FIX for Your Validation Error

## Your Error:
```
ERROR ~ Validation of pipeline parameters failed!
* --input (/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly): is not a file, but a directory
```

## ⚡ Quick Fix (2 commands):

```bash
# 1. Create samplesheet from your directory
./create_samplesheet_from_directory.sh /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly

# 2. Run pipeline with the samplesheet
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 📝 What This Does:

1. **Script finds all your assembly files** (.fasta, .fa, .fna) in the directory
2. **Creates a proper CSV samplesheet** that the pipeline expects
3. **You run the pipeline** with the CSV file instead of the directory

## ✅ Expected Output:

```
✅ Samplesheet created: samplesheet.csv

Contents:
sample,assembly
sample1,/home/kornthara/.../Assembly/file1.fasta
sample2,/home/kornthara/.../Assembly/file2.fasta
sample3,/home/kornthara/.../Assembly/file3.fasta
...

Now you can run the pipeline with:
  nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 🎯 Key Point:

**Never pass directories directly to `--input`. Always use a CSV samplesheet file.**

That's it! This fixes your validation error completely.