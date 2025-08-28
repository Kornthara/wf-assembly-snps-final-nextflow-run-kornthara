# Assembly SNPs Pipeline - Complete Solution

## Overview

This pipeline has been specifically designed and optimized to resolve the PARSNP error you encountered and run efficiently on your 12-core, 64GB RAM system.

## Key Fixes Implemented

### 1. **Directory Handling Fix** ⭐ **CRITICAL FIX**
- **Problem**: `cp` command failed when input paths were directories
- **Solution**: Automatic detection and proper handling of both files and directories
- **Impact**: Eliminates the most common cause of PARSNP failures

### 2. **PARSNP Error Resolution**
- **Problem**: Process terminated with exit status 1
- **Solutions**:
  - Fixed hyphen handling in sequence names
  - Proper resource allocation (8 CPUs, 32GB RAM)
  - Enhanced error reporting and debugging
  - File validation and size checks

### 3. **Resource Optimization**
- **Configuration**: Optimized for 12-core, 64GB RAM systems
- **Profile**: `local_12core` profile with proper resource limits
- **Efficiency**: Prevents resource contention and memory issues

## Pipeline Components

### Core Modules
1. **PARSNP** (Local) - Core genome alignment with fixes
2. **HarvestTools** (Local) - Convert PARSNP output to FASTA
3. **SNPdists** (nf-core) - Calculate SNP distances
4. **SNPsites** (nf-core) - Extract SNP sites
5. **FastQC** (nf-core) - Quality control
6. **MultiQC** (nf-core) - Aggregate reporting

### Input Flexibility
- **File inputs**: Traditional FASTA files
- **Directory inputs**: Directories containing FASTA files
- **Mixed inputs**: Combination of files and directories
- **Auto-detection**: Automatic file type recognition

## Quick Start

### 1. Basic Usage
```bash
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core
```

### 2. With Resource Limits
```bash
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core
```

### 3. Resume Failed Runs
```bash
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## Testing and Validation

### Comprehensive Test Suite
```bash
# Test pipeline structure and configuration
./test_pipeline.sh

# Test directory handling fix
./test_directory_handling.sh
```

### Test Cases Covered
1. **Directory inputs** (previously failing)
2. **File inputs** (traditional)
3. **Mixed inputs** (files + directories)
4. **Resource allocation**
5. **Error handling**

## File Structure

```
nf-core-assemblysnps/
├── main.nf                           # Main pipeline script
├── nextflow.config                   # Main configuration
├── workflows/assemblysnps.nf         # Core workflow logic
├── modules/
│   ├── local/
│   │   ├── parsnp/                   # Fixed PARSNP module
│   │   └── harvesttools/             # HarvestTools module
│   └── nf-core/                      # Standard nf-core modules
├── conf/
│   ├── modules.config                # Module-specific config
│   └── local_12core.config           # 12-core system config
├── assets/
│   └── samplesheet_example.csv       # Example samplesheet
├── README_LOCAL_SETUP.md             # Setup instructions
├── TROUBLESHOOTING_PARSNP.md         # PARSNP troubleshooting
├── DIRECTORY_HANDLING_FIX.md         # Directory fix details
├── test_pipeline.sh                  # Pipeline validation
└── test_directory_handling.sh        # Directory handling tests
```

## Output Files

### PARSNP Results
- `*.ggr` - Gingr format alignment
- `*.xmfa` - Multi-FASTA alignment
- `*.tree` - Phylogenetic tree
- `*.SNPs.fa.gz` - SNP sequences (compressed)
- `*_summary.tsv` - Quality control summary

### Analysis Results
- `snpdists/` - SNP distance matrices
- `snpsites/` - Extracted SNP sites
- `harvesttools/` - Converted alignments
- `multiqc/` - Quality control report

## Performance Characteristics

### Resource Usage (12-core system)
- **PARSNP**: 8 CPUs, 32GB RAM, 12h timeout
- **Other processes**: 2-6 CPUs, 8-16GB RAM
- **Total pipeline**: ~2-8 hours depending on dataset size

### Scalability
- **Small datasets** (3-10 genomes): 1-2 hours
- **Medium datasets** (10-50 genomes): 2-6 hours
- **Large datasets** (50+ genomes): 6+ hours

## Troubleshooting Quick Reference

### Common Issues and Solutions

1. **PARSNP fails with exit status 1**
   - Check input file formats (FASTA required)
   - Verify sufficient disk space
   - Ensure genomes are from related organisms

2. **Memory errors**
   - Reduce `--max_memory` parameter
   - Use fewer input genomes
   - Check available system memory

3. **Directory not found errors**
   - Verify all paths in samplesheet exist
   - Use absolute paths when possible
   - Check file permissions

4. **Long runtime**
   - Reduce number of input genomes
   - Use faster storage (SSD)
   - Increase CPU allocation

## Support and Documentation

### Key Documents
- `README_LOCAL_SETUP.md` - Complete setup guide
- `TROUBLESHOOTING_PARSNP.md` - PARSNP-specific issues
- `DIRECTORY_HANDLING_FIX.md` - Technical details of the fix

### Validation
- All modules tested and validated
- Resource limits verified for 12-core systems
- Directory handling thoroughly tested
- Error conditions properly handled

## Success Metrics

✅ **Fixed PARSNP exit status 1 error**  
✅ **Resolved directory copying issues**  
✅ **Optimized for 12-core, 64GB RAM systems**  
✅ **Comprehensive error handling and debugging**  
✅ **Flexible input handling (files/directories)**  
✅ **Complete test suite included**  
✅ **Production-ready configuration**  

## Next Steps

1. **Download the pipeline** from the sandbox
2. **Run the test suite** to validate your environment
3. **Prepare your samplesheet** with assembly files/directories
4. **Execute the pipeline** with the `local_12core` profile
5. **Monitor progress** using Nextflow reports

The pipeline is now ready for production use on your 12-core system and should successfully resolve the PARSNP errors you encountered.