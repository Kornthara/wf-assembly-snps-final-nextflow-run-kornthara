#!/bin/bash

# Comprehensive test script for directory handling fix
# Tests both file and directory inputs to ensure the PARSNP module works correctly

set -e  # Exit on any error

echo "=== Assembly SNPs Pipeline - Directory Handling Test ==="
echo "Testing the fix for cp command errors with directory inputs"
echo ""

# Clean up any previous test runs
rm -rf test_data test_results_* work .nextflow*

# Create test data structure
echo "Creating test data..."
mkdir -p test_data/assemblies_dir1 test_data/assemblies_dir2 test_data/single_files

# Create sample FASTA files in directories
cat > test_data/assemblies_dir1/sample1.fasta << 'EOF'
>sample1_contig1
ATGCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGA
>sample1_contig2
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
EOF

cat > test_data/assemblies_dir2/sample2.fasta << 'EOF'
>sample2_contig1
ATGCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGA
>sample2_contig2
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
EOF

# Create single files
cp test_data/assemblies_dir1/sample1.fasta test_data/single_files/sample3.fasta
cp test_data/assemblies_dir2/sample2.fasta test_data/single_files/sample4.fasta

# Modify sequences slightly to make them different
sed -i 's/ATGC/TTGC/g' test_data/single_files/sample3.fasta
sed -i 's/GCTA/ACTA/g' test_data/single_files/sample4.fasta

echo "✓ Test data created"

# Test Case 1: Directory inputs (previously failing)
echo ""
echo "=== Test Case 1: Directory Inputs ==="
cat > test_samplesheet_dirs.csv << EOF
sample,assembly
sample1,test_data/assemblies_dir1
sample2,test_data/assemblies_dir2
EOF

echo "Samplesheet content:"
cat test_samplesheet_dirs.csv
echo ""

echo "Testing pipeline with directory inputs..."
if nextflow run . \
    --input test_samplesheet_dirs.csv \
    --outdir test_results_dirs \
    -profile local_12core \
    -with-report test_report_dirs.html \
    -with-trace test_trace_dirs.txt; then
    echo "✓ Directory inputs test PASSED"
    test1_passed=true
else
    echo "✗ Directory inputs test FAILED"
    test1_passed=false
fi

# Test Case 2: File inputs (should still work)
echo ""
echo "=== Test Case 2: File Inputs ==="
cat > test_samplesheet_files.csv << EOF
sample,assembly
sample3,test_data/single_files/sample3.fasta
sample4,test_data/single_files/sample4.fasta
EOF

echo "Samplesheet content:"
cat test_samplesheet_files.csv
echo ""

echo "Testing pipeline with file inputs..."
if nextflow run . \
    --input test_samplesheet_files.csv \
    --outdir test_results_files \
    -profile local_12core \
    -with-report test_report_files.html \
    -with-trace test_trace_files.txt \
    -resume; then
    echo "✓ File inputs test PASSED"
    test2_passed=true
else
    echo "✗ File inputs test FAILED"
    test2_passed=false
fi

# Test Case 3: Mixed inputs
echo ""
echo "=== Test Case 3: Mixed Inputs ==="
cat > test_samplesheet_mixed.csv << EOF
sample,assembly
sample1,test_data/assemblies_dir1
sample4,test_data/single_files/sample4.fasta
EOF

echo "Samplesheet content:"
cat test_samplesheet_mixed.csv
echo ""

echo "Testing pipeline with mixed inputs..."
if nextflow run . \
    --input test_samplesheet_mixed.csv \
    --outdir test_results_mixed \
    -profile local_12core \
    -with-report test_report_mixed.html \
    -with-trace test_trace_mixed.txt \
    -resume; then
    echo "✓ Mixed inputs test PASSED"
    test3_passed=true
else
    echo "✗ Mixed inputs test FAILED"
    test3_passed=false
fi

# Summary
echo ""
echo "=== Test Summary ==="
echo "Test Case 1 (Directory inputs): $([ "$test1_passed" = true ] && echo "PASSED" || echo "FAILED")"
echo "Test Case 2 (File inputs): $([ "$test2_passed" = true ] && echo "PASSED" || echo "FAILED")"
echo "Test Case 3 (Mixed inputs): $([ "$test3_passed" = true ] && echo "PASSED" || echo "FAILED")"

# Check outputs
echo ""
echo "=== Output Validation ==="
for result_dir in test_results_*; do
    if [[ -d "$result_dir" ]]; then
        echo "Checking $result_dir:"
        echo "  - PARSNP outputs: $(find $result_dir -name "*.ggr" -o -name "*.xmfa" -o -name "*.tree" | wc -l) files"
        echo "  - SNP distances: $(find $result_dir -name "*distances*" | wc -l) files"
        echo "  - MultiQC report: $(find $result_dir -name "multiqc_report.html" | wc -l) files"
    fi
done

# Performance metrics
echo ""
echo "=== Performance Metrics ==="
if [[ -f "test_trace_dirs.txt" ]]; then
    echo "PARSNP process performance (directory inputs):"
    grep "PARSNP" test_trace_dirs.txt | awk '{print "  CPU time: " $17 ", Memory: " $15 ", Duration: " $4}'
fi

if [[ -f "test_trace_files.txt" ]]; then
    echo "PARSNP process performance (file inputs):"
    grep "PARSNP" test_trace_files.txt | awk '{print "  CPU time: " $17 ", Memory: " $15 ", Duration: " $4}'
fi

# Cleanup option
echo ""
read -p "Clean up test files? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleaning up..."
    rm -rf test_data test_results_* work .nextflow* test_*.csv test_*.html test_*.txt
    echo "✓ Cleanup complete"
else
    echo "Test files preserved for inspection"
    echo "To clean up later, run: rm -rf test_data test_results_* work .nextflow* test_*.csv test_*.html test_*.txt"
fi

# Final status
if [[ "$test1_passed" = true && "$test2_passed" = true && "$test3_passed" = true ]]; then
    echo ""
    echo "🎉 All tests PASSED! The directory handling fix is working correctly."
    exit 0
else
    echo ""
    echo "❌ Some tests FAILED. Check the logs above for details."
    exit 1
fi