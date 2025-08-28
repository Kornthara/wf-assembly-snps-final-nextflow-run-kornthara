# Directory Handling Fix for PARSNP Module

## Issue Description

The original PARSNP module had a critical bug where `cp` commands would fail if input paths were directories instead of files, because `cp` requires the `-r` flag to copy directories recursively.

## Error Symptoms

```bash
cp: omitting directory '/path/to/assemblies'
cp: cannot stat '/path/to/assemblies': Is a directory
```

## Fix Implementation

The updated PARSNP module now includes robust file/directory handling:

### 1. Assembly File Handling

```bash
for assembly in ${assemblies}; do
    if [[ -d "$assembly" ]]; then
        # If it's a directory, copy recursively
        cp -r "$assembly"/* genomes/ 2>/dev/null || cp -r "$assembly" genomes/
    elif [[ -f "$assembly" ]]; then
        # If it's a file, copy normally
        cp "$assembly" genomes/
    else
        echo "Warning: $assembly is neither a file nor directory"
    fi
done
```

### 2. Reference File Handling

```bash
if [[ -d "${reference}" ]]; then
    # If reference is a directory, find the first FASTA file
    ref_file=$(find ${reference} -name "*.fasta" -o -name "*.fa" -o -name "*.fna" | head -1)
    if [[ -n "$ref_file" ]]; then
        cp "$ref_file" $ref_clean
    else
        echo "Error: No FASTA files found in reference directory ${reference}"
        exit 1
    fi
else
    # If reference is a file, copy normally
    cp ${reference} $ref_clean
fi
```

### 3. Enhanced Debugging

The module now provides detailed diagnostic information:

- File existence checks
- File size validation
- Directory content listing
- Resource usage information
- Disk space availability

## Testing the Fix

### Test Case 1: File Inputs (Original Working Case)
```bash
# Samplesheet with file paths
sample1,/path/to/sample1.fasta
sample2,/path/to/sample2.fasta
```

### Test Case 2: Directory Inputs (Previously Failing)
```bash
# Samplesheet with directory paths
sample1,/path/to/assemblies_dir/
sample2,/path/to/another_assemblies_dir/
```

### Test Case 3: Mixed Inputs
```bash
# Samplesheet with mixed file and directory paths
sample1,/path/to/sample1.fasta
sample2,/path/to/assemblies_dir/
```

## Validation Script

Run this to test the fix:

```bash
#!/bin/bash
# Test directory handling

# Create test structure
mkdir -p test_assemblies/sample1 test_assemblies/sample2
echo ">seq1" > test_assemblies/sample1/assembly.fasta
echo "ATCGATCG" >> test_assemblies/sample1/assembly.fasta
echo ">seq2" > test_assemblies/sample2/assembly.fasta
echo "GCTAGCTA" >> test_assemblies/sample2/assembly.fasta

# Create test samplesheet with directories
cat > test_samplesheet_dirs.csv << EOF
sample,assembly
sample1,test_assemblies/sample1/
sample2,test_assemblies/sample2/
EOF

# Test the pipeline
nextflow run . \
    --input test_samplesheet_dirs.csv \
    --outdir test_results_dirs \
    -profile local_12core \
    -resume
```

## Additional Improvements

1. **File Type Detection**: Automatically detects FASTA files by extension (.fasta, .fa, .fna)
2. **Error Recovery**: Graceful handling of missing files or directories
3. **Resource Monitoring**: Real-time resource usage reporting
4. **Detailed Logging**: Comprehensive error messages for troubleshooting

## Backward Compatibility

The fix maintains full backward compatibility:
- Existing pipelines with file inputs continue to work unchanged
- New functionality handles directory inputs seamlessly
- No changes required to existing samplesheets or configurations

## Performance Impact

- Minimal overhead from file type checking
- Improved reliability reduces failed runs and reruns
- Better error messages reduce debugging time