#!/bin/bash

# Prepare Assembly SNPs Pipeline for Download
# This script cleans up the pipeline and prepares it for distribution

echo "=== Preparing Assembly SNPs Pipeline for Download ==="

# Clean up any test artifacts
echo "Cleaning up test artifacts..."
rm -rf work .nextflow* test_data test_results_* test_*.csv test_*.html test_*.txt

# Ensure all scripts are executable
echo "Setting executable permissions..."
chmod +x test_pipeline.sh
chmod +x test_directory_handling.sh
chmod +x prepare_for_download.sh

# Validate pipeline structure
echo "Validating pipeline structure..."
required_files=(
    "main.nf"
    "nextflow.config"
    "workflows/assemblysnps.nf"
    "modules/local/parsnp/main.nf"
    "modules/local/parsnp/environment.yml"
    "modules/local/harvesttools/main.nf"
    "modules/local/harvesttools/environment.yml"
    "modules/nf-core/snpdists/main.nf"
    "modules/nf-core/snpsites/main.nf"
    "modules/nf-core/fastqc/main.nf"
    "modules/nf-core/multiqc/main.nf"
    "conf/modules.config"
    "conf/local_12core.config"
    "nextflow_schema.json"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -eq 0 ]]; then
    echo "✓ All required files present"
else
    echo "✗ Missing files:"
    printf '  %s\n' "${missing_files[@]}"
    exit 1
fi

# Test pipeline syntax
echo "Testing pipeline syntax..."
if nextflow run . --help &> /dev/null; then
    echo "✓ Pipeline syntax is valid"
else
    echo "✗ Pipeline syntax error"
    exit 1
fi

# Create a summary of what's included
echo "Creating package summary..."
cat > PACKAGE_CONTENTS.md << 'EOF'
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
EOF

# Display package information
echo ""
echo "=== Package Summary ==="
echo "Pipeline: nf-core/assemblysnps"
echo "Version: 1.0.0dev"
echo "Optimized for: 12-core, 64GB RAM systems"
echo "Key fix: Directory handling in PARSNP module"
echo ""
echo "Files included:"
find . -type f -name "*.nf" -o -name "*.config" -o -name "*.yml" -o -name "*.md" -o -name "*.sh" -o -name "*.csv" -o -name "*.json" | grep -v ".nextflow" | sort

echo ""
echo "Total size: $(du -sh . | cut -f1)"
echo ""
echo "=== Ready for Download ==="
echo "The pipeline is now ready for download and use."
echo ""
echo "Quick start after download:"
echo "1. Extract the pipeline files"
echo "2. Run: ./test_pipeline.sh"
echo "3. Create your samplesheet.csv"
echo "4. Run: nextflow run . --input samplesheet.csv --outdir results -profile local_12core"
echo ""
echo "For detailed instructions, see README_LOCAL_SETUP.md"