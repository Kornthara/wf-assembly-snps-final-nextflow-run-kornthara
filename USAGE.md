# Assembly SNPs Pipeline Usage

This pipeline performs assembly-based SNP calling and phylogenetic analysis using PARSNP and related tools.

## Quick Start

1. **Prepare your samplesheet** (CSV format):

```csv
sample,assembly
sample1,/path/to/sample1_assembly.fasta
sample2,/path/to/sample2_assembly.fasta
sample3,/path/to/sample3_assembly.fasta
```

2. **Run the pipeline** (optimized for 12 cores, 64GB RAM):

```bash
nextflow run . \
    -profile local,conda \
    --input samplesheet.csv \
    --outdir results
```

## Key Features

- **PARSNP**: Core genome alignment and SNP calling
- **SNP-sites**: Extract SNP positions from alignments
- **SNP-dists**: Calculate pairwise SNP distances
- **FastQC**: Quality control of input assemblies
- **MultiQC**: Aggregate quality control reports

## Configuration

The pipeline is pre-configured for local execution with:

- **CPUs**: Up to 12 cores (8 cores for PARSNP)
- **Memory**: Up to 64GB RAM (16GB for PARSNP)
- **Time**: Up to 240 hours maximum runtime

## Troubleshooting

### PARSNP Issues

The custom PARSNP module includes fixes for common issues:

- Automatic cleaning of reference sequence deflines (removes hyphens)
- Proper error handling and file verification
- Optimized resource allocation

### Resource Requirements

- Minimum 8GB RAM recommended
- At least 4 CPU cores for reasonable performance
- Sufficient disk space for intermediate files

## Output Files

- `parsnp/`: PARSNP alignment and tree files
- `snp_distances/`: Pairwise SNP distance matrices
- `fastqc/`: Quality control reports
- `multiqc/`: Aggregated quality control report
- `pipeline_info/`: Execution reports and logs
