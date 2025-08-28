#!/bin/bash

# Test script for Assembly SNPs Pipeline
# This script validates the pipeline setup and configuration

echo "=== Assembly SNPs Pipeline Test ==="
echo "Testing pipeline configuration and dependencies..."

# Check if Nextflow is available
if command -v nextflow &> /dev/null; then
    echo "✓ Nextflow is installed: $(nextflow -version | head -1)"
else
    echo "✗ Nextflow not found. Please install Nextflow first."
    exit 1
fi

# Check if conda/mamba is available
if command -v mamba &> /dev/null; then
    echo "✓ Mamba is available: $(mamba --version)"
elif command -v conda &> /dev/null; then
    echo "✓ Conda is available: $(conda --version)"
else
    echo "⚠ Neither conda nor mamba found. You may need to install conda for dependency management."
fi

# Validate pipeline structure
echo ""
echo "=== Pipeline Structure Validation ==="

required_files=(
    "main.nf"
    "nextflow.config"
    "workflows/assemblysnps.nf"
    "modules/local/parsnp/main.nf"
    "modules/local/harvesttools/main.nf"
    "modules/nf-core/snpdists/main.nf"
    "modules/nf-core/snpsites/main.nf"
    "conf/modules.config"
    "conf/local_12core.config"
)

for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
    fi
done

# Test pipeline syntax
echo ""
echo "=== Pipeline Syntax Check ==="
if nextflow run . --help &> /dev/null; then
    echo "✓ Pipeline syntax is valid"
else
    echo "✗ Pipeline syntax error detected"
    echo "Run 'nextflow run . --help' for details"
fi

# Check schema
echo ""
echo "=== Schema Validation ==="
if [[ -f "nextflow_schema.json" ]]; then
    echo "✓ Pipeline schema exists"
    param_count=$(grep -o '"type"' nextflow_schema.json | wc -l)
    echo "  Found $param_count parameters in schema"
else
    echo "✗ Pipeline schema missing"
fi

echo ""
echo "=== Configuration Test ==="
echo "Testing local_12core profile..."

# Test configuration loading
if nextflow config -profile local_12core &> /dev/null; then
    echo "✓ local_12core profile loads successfully"
    
    # Show key configuration values
    echo "Key configuration values:"
    echo "  Max CPUs: $(nextflow config -profile local_12core | grep 'max_cpus' | head -1 | awk '{print $3}')"
    echo "  Max Memory: $(nextflow config -profile local_12core | grep 'max_memory' | head -1 | awk '{print $3}')"
    echo "  Executor: $(nextflow config -profile local_12core | grep 'executor' | head -1 | awk '{print $3}')"
else
    echo "✗ Error loading local_12core profile"
fi

echo ""
echo "=== Test Summary ==="
echo "Pipeline is ready for execution with the following command:"
echo ""
echo "nextflow run . \\"
echo "    --input samplesheet.csv \\"
echo "    --outdir results \\"
echo "    -profile local_12core"
echo ""
echo "Make sure to:"
echo "1. Create a samplesheet.csv with your assembly files"
echo "2. Ensure all assembly files exist and are readable"
echo "3. Have sufficient disk space for outputs"
echo "4. Install conda/mamba if using conda profile"
echo ""
echo "For more details, see README_LOCAL_SETUP.md"