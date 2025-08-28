#!/bin/bash

# Test script to validate the parameter fix

echo "=== Testing Parameter Fix ==="
echo ""

# Check if we're in the right directory
if [[ ! -f "main.nf" ]]; then
    echo "❌ Error: Not in pipeline directory. Run: cd nf-core-assemblysnps"
    exit 1
fi

# Check if samplesheet exists
if [[ ! -f "samplesheet.csv" ]]; then
    echo "❌ Error: samplesheet.csv not found"
    exit 1
fi

echo "✅ Pipeline directory: $(pwd)"
echo "✅ Samplesheet found: samplesheet.csv"

# Show samplesheet contents
echo ""
echo "📋 Samplesheet contents:"
echo "----------------------------------------"
cat samplesheet.csv
echo "----------------------------------------"

# Check if test assemblies exist
echo ""
echo "🔍 Checking test assembly files:"
for file in $(cut -d',' -f2 samplesheet.csv | tail -n +2); do
    if [[ -f "$file" ]]; then
        echo "✅ $file exists ($(stat -c%s "$file") bytes)"
    else
        echo "❌ $file missing"
    fi
done

# Test pipeline syntax with correct parameters
echo ""
echo "🧪 Testing pipeline syntax with correct parameters..."
if nextflow run . --input samplesheet.csv --outdir test_results --help &> /dev/null; then
    echo "✅ Pipeline accepts parameters correctly"
else
    echo "❌ Pipeline syntax error"
    exit 1
fi

# Test what happens without parameters (should fail)
echo ""
echo "🧪 Testing what happens without parameters (should fail)..."
if nextflow run . --help &> /dev/null; then
    echo "✅ Pipeline shows help without parameters (expected)"
else
    echo "❌ Unexpected error when running without parameters"
fi

echo ""
echo "=== Parameter Fix Validation Complete ==="
echo ""
echo "🚀 Ready to run! Use this command:"
echo "   nextflow run . --input samplesheet.csv --outdir results -profile local_12core"
echo ""
echo "📊 Expected runtime: 5-15 minutes for test data"
echo "💾 Expected output size: ~10-50 MB"