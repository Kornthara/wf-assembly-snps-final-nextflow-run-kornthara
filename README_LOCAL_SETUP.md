# Assembly SNPs Pipeline - Local 12-Core Setup

This pipeline performs assembly-based SNP calling and phylogenetic analysis using PARSNP and related tools.

## Quick Start for 12-Core System

### Prerequisites
- Nextflow (>= 23.04.0)
- Conda/Mamba or Singularity/Docker
- At least 12 CPU cores and 64GB RAM

### Installation
```bash
# Install Nextflow
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/

# Install Conda/Mamba (if not already installed)
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
```

### Running the Pipeline

1. **Prepare your input samplesheet** (CSV format):

The pipeline supports both file and directory inputs:

**File inputs** (traditional):
```csv
sample,assembly
sample1,/path/to/sample1.fasta
sample2,/path/to/sample2.fasta
sample3,/path/to/sample3.fasta
```

**Directory inputs** (new feature):
```csv
sample,assembly
sample1,/path/to/assemblies_dir1/
sample2,/path/to/assemblies_dir2/
sample3,/path/to/assemblies_dir3/
```

**Mixed inputs** (files and directories):
```csv
sample,assembly
sample1,/path/to/sample1.fasta
sample2,/path/to/assemblies_dir/
sample3,/path/to/sample3.fasta
```

2. **Run the pipeline with the local 12-core configuration**:
```bash
nextflow run . \\
    --input samplesheet.csv \\
    --outdir results \\
    -profile local_12core \\
    -c conf/local_12core.config
```

### Configuration Details

The `local_12core` profile is optimized for your system:
- **Max CPUs**: 12
- **Max Memory**: 64GB
- **Max Time**: 24 hours
- **PARSNP Process**: 8 CPUs, 32GB RAM, 12h timeout

### Troubleshooting PARSNP Errors

The pipeline includes several fixes for common PARSNP issues:

1. **Directory handling**: Supports both file and directory inputs with proper `cp -r` handling
2. **Hyphen handling**: Automatically removes hyphens from reference sequences
3. **File validation**: Checks for minimum file sizes and proper outputs
4. **Resource management**: Properly configured CPU and memory limits
5. **Error reporting**: Detailed error messages for debugging

### Directory Input Support

**NEW FEATURE**: The pipeline now handles directory inputs correctly, fixing the common `cp` command error:

- **Automatic detection**: Distinguishes between files and directories
- **Recursive copying**: Uses `cp -r` for directories automatically
- **FASTA file discovery**: Finds FASTA files within directories (.fasta, .fa, .fna)
- **Error recovery**: Graceful handling of missing files or invalid paths

Test the directory handling with:
```bash
./test_directory_handling.sh
```

### Output Files

The pipeline produces:
- `parsnp/`: Core genome alignment files (.ggr, .xmfa, .tree, .SNPs.fa.gz)
- `harvesttools/`: Converted FASTA alignments
- `snpdists/`: SNP distance matrices
- `snpsites/`: Extracted SNP sites
- `multiqc/`: Quality control report

### Memory and CPU Optimization

If you encounter memory issues:
1. Reduce `max_memory` in the config file
2. Adjust process-specific memory limits
3. Use `--max_memory` parameter

For CPU optimization:
1. Adjust `max_cpus` based on your system
2. Modify process-specific CPU allocations
3. Use `--max_cpus` parameter

### Example Commands

**Basic run**:
```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

**With custom resource limits**:
```bash
nextflow run . \\
    --input samplesheet.csv \\
    --outdir results \\
    --max_memory 32.GB \\
    --max_cpus 8 \\
    -profile local_12core
```

**Resume a failed run**:
```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core -resume
```

### Support

If you encounter issues:
1. Check the `.nextflow.log` file for detailed error messages
2. Verify your input files are valid FASTA format
3. Ensure you have sufficient disk space
4. Check that all dependencies are properly installed