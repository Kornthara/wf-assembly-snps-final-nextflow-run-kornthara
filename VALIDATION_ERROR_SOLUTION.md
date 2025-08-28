# Complete Solution for Pipeline Validation Error

## 🚨 Your Error

```
ERROR ~ Validation of pipeline parameters failed!
* --input (/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly): is not a file, but a directory
* --input (/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly): does not match regular expression [^\S+\.csv$]
```

## 🎯 The Problem

You tried to run:
```bash
nextflow run . --input /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
```

But the pipeline expects a **CSV samplesheet file**, not a directory path.

## ✅ The Solution

### Step 1: Create a Samplesheet from Your Assembly Directory

```bash
./create_samplesheet_from_directory.sh /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
```

This script will:
1. Find all assembly files (.fasta, .fa, .fna) in your directory
2. Create a proper CSV samplesheet
3. Show you the exact command to run the pipeline

### Step 2: Run the Pipeline with the Generated Samplesheet

```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 📋 Example Output

When you run the script, you'll see something like:

```
Searching for assembly files in: /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly
Found 5 assembly files
Added: sample1 -> /home/kornthara/.../Assembly/sample1.fasta
Added: sample2 -> /home/kornthara/.../Assembly/sample2.fasta
Added: sample3 -> /home/kornthara/.../Assembly/sample3.fasta
Added: sample4 -> /home/kornthara/.../Assembly/sample4.fasta
Added: sample5 -> /home/kornthara/.../Assembly/sample5.fasta

✅ Samplesheet created: samplesheet.csv

Contents:
----------------------------------------
sample,assembly
sample1,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample1.fasta
sample2,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample2.fasta
sample3,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample3.fasta
sample4,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample4.fasta
sample5,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/sample5.fasta
----------------------------------------

Now you can run the pipeline with:
  nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 🔧 Manual Alternative

If you prefer to create the samplesheet manually:

1. **Check your assembly files:**
   ```bash
   ls -la /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/
   ```

2. **Create samplesheet.csv:**
   ```bash
   cat > samplesheet.csv << 'EOF'
   sample,assembly
   sample1,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/your_file1.fasta
   sample2,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/your_file2.fasta
   sample3,/home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/your_file3.fasta
   EOF
   ```

## 🚀 Complete Workflow

```bash
# 1. Navigate to the pipeline directory
cd nf-core-assemblysnps

# 2. Create samplesheet from your assembly directory
./create_samplesheet_from_directory.sh /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly

# 3. Verify the samplesheet looks correct
cat samplesheet.csv

# 4. Run the pipeline with your 12-core system configuration
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core

# 5. If the run fails and you need to resume
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## 🔍 Troubleshooting

### If no assembly files are found:

```bash
# Check what files are actually in your directory
find /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly -type f -name "*"

# Look for different file extensions
find /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly -type f \( -name "*.fasta" -o -name "*.fa" -o -name "*.fna" -o -name "*.fas" -o -name "*.contigs" \)
```

### If you get permission errors:

```bash
# Check permissions
ls -la /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/

# Fix permissions if needed
chmod +r /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly/*
```

### If the pipeline still fails:

1. Check the `.nextflow.log` file for detailed error messages
2. Verify all assembly files exist and are readable
3. Ensure you have sufficient disk space
4. Check that all file paths in the samplesheet are correct

## 📊 Expected Results

After successful completion, you'll find:

```
results/
├── parsnp/                    # Core genome alignment results
│   ├── *.ggr                 # Gingr format files
│   ├── *.xmfa                # Multi-FASTA alignment
│   ├── *.tree                # Phylogenetic tree
│   └── *.SNPs.fa.gz          # SNP sequences
├── snpdists/                  # SNP distance matrices
├── snpsites/                  # Extracted SNP sites
├── harvesttools/              # Converted alignments
├── multiqc/                   # Quality control report
└── pipeline_info/             # Execution reports
```

## 🎉 Success!

Once you follow these steps, your pipeline should run successfully without the validation error. The key is always using a **CSV samplesheet file** instead of passing directory paths directly to the `--input` parameter.