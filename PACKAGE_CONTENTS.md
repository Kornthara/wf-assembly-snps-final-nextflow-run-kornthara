# Assembly SNPs Pipeline Package Contents

## Core Pipeline Files
- `main.nf` - Main pipeline entry point
- `nextflow.config` - Main configuration file
- `nextflow_schema.json` - Parameter schema
- `workflows/assemblysnps.nf` - Core workflow logic

## Modules
### Local Modules (Custom)
- `modules/local/parsnp/` - Fixed PARSNP module with directory handling
- `modules/local/harvesttools/` - HarvestTools for format conversion

### nf-core Modules (Standard)
- `modules/nf-core/snpdists/` - SNP distance calculation
- `modules/nf-core/snpsites/` - SNP site extraction
- `modules/nf-core/fastqc/` - Quality control
- `modules/nf-core/multiqc/` - Report aggregation

## Configuration
- `conf/modules.config` - Module-specific configurations
- `conf/local_12core.config` - Optimized config for 12-core systems

## Documentation
- `README_LOCAL_SETUP.md` - Complete setup and usage guide
- `TROUBLESHOOTING_PARSNP.md` - PARSNP-specific troubleshooting
- `DIRECTORY_HANDLING_FIX.md` - Technical details of directory fix
- `PIPELINE_SUMMARY.md` - Complete solution overview

## Testing and Validation
- `test_pipeline.sh` - Pipeline structure and syntax validation
- `test_directory_handling.sh` - Comprehensive directory handling tests

## Examples
- `assets/samplesheet_example.csv` - Example input samplesheet

## Key Features
✅ Fixed PARSNP exit status 1 error
✅ Directory input support (cp -r fix)
✅ Optimized for 12-core, 64GB RAM systems
✅ Comprehensive error handling
✅ Production-ready configuration
✅ Complete test suite
