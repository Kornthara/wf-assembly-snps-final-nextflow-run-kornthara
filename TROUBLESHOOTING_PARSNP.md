# PARSNP Troubleshooting Guide

This guide addresses common PARSNP errors and their solutions, specifically for the error you encountered.

## Common PARSNP Error: Exit Status 1

### Error Description
```
ERROR ~ Error executing process > 'ASSEMBLY_SNPS:CORE_GENOME_ALIGNMENT_PARSNP (Parsnp)'
Caused by:
  Process `ASSEMBLY_SNPS:CORE_GENOME_ALIGNMENT_PARSNP (Parsnp)` terminated with an error exit status (1)
```

### Root Causes and Solutions

#### 1. **Hyphen Issues in Sequence Names**
**Problem**: PARSNP v1.2+ has issues with hyphens in sequence deflines.
**Solution**: Our pipeline automatically removes hyphens from both filenames and sequence headers.

```bash
# The pipeline automatically does this:
sed -i "s/-/_/g" reference.fasta
```

#### 2. **Insufficient Memory/CPU Resources**
**Problem**: PARSNP requires adequate resources for large datasets.
**Solution**: Use the `local_12core` profile which allocates:
- 8 CPUs for PARSNP
- 32GB RAM
- 12-hour timeout

#### 3. **File Path Issues**
**Problem**: Long paths or special characters can cause issues.
**Solution**: The pipeline copies files to a clean working directory.

#### 4. **Assembly Quality Issues**
**Problem**: Poor quality assemblies or very different genomes.
**Solution**: 
- Ensure assemblies are from closely related organisms
- Check assembly quality with FastQC (included in pipeline)
- Use `--curated` flag (automatically included)

#### 5. **Thread Configuration**
**Problem**: Incorrect thread specification.
**Solution**: Pipeline uses `${task.cpus}` which is properly configured.

### Specific Fixes Implemented

Our PARSNP module includes these error-prevention measures:

1. **File Cleaning**:
   ```bash
   # Clean reference filename
   ref_clean=$(basename ${reference} | sed 's/-/_/g')
   # Clean sequence headers
   sed -i 's/-/_/g' $ref_clean
   ```

2. **Resource Management**:
   ```bash
   parsnp \
       --threads ${task.cpus} \
       --max-partition-size 15000000
   ```

3. **Error Handling**:
   ```bash
   parsnp ... || {
       echo "PARSNP failed. Checking for common issues..."
       echo "Reference file: $ref_clean"
       echo "Number of assemblies: $(ls genomes/ | wc -l)"
       ls -la genomes/
       exit 1
   }
   ```

4. **Output Validation**:
   ```bash
   for file in ${prefix}.ggr ${prefix}.xmfa ${prefix}.SNPs.fa; do
       if [[ -s "$file" && $(stat -c%s "$file") -gt 1000 ]]; then
           echo -e "NaN\t${file} Output File\tPASS"
       else
           echo -e "NaN\t${file} Output File\tFAIL"
       fi
   done
   ```

### Running with Optimal Settings

Use this command for your 12-core system:

```bash
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    --max_memory 64.GB \
    --max_cpus 12
```

### Debugging Steps

If PARSNP still fails:

1. **Check Input Files**:
   ```bash
   # Verify assemblies exist and are readable
   for file in $(cut -d',' -f2 samplesheet.csv | tail -n +2); do
       echo "Checking $file"
       ls -la "$file"
       head -5 "$file"
   done
   ```

2. **Test with Fewer Samples**:
   Create a smaller samplesheet with 3-4 assemblies first.

3. **Check Available Resources**:
   ```bash
   # Check available memory
   free -h
   # Check CPU count
   nproc
   ```

4. **Manual PARSNP Test**:
   ```bash
   # Test PARSNP manually
   mkdir test_genomes
   cp assembly1.fasta assembly2.fasta test_genomes/
   parsnp -d test_genomes -r assembly1.fasta -o test_output -v -c -p 8
   ```

### Alternative Approaches

If PARSNP continues to fail:

1. **Use Different Reference**: Try a different assembly as reference
2. **Reduce Dataset Size**: Start with fewer, more similar assemblies
3. **Check Assembly Quality**: Use tools like QUAST to assess assembly quality

### Memory Optimization

For systems with less than 64GB RAM:

```bash
# Reduce memory allocation
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    --max_memory 32.GB \
    --max_cpus 8
```

### Contact and Support

If issues persist:
1. Check the `.nextflow.log` file for detailed error messages
2. Examine the `work/` directory for intermediate files
3. Review the PARSNP documentation: https://github.com/marbl/parsnp

The pipeline is designed to handle the most common PARSNP issues automatically, but genome diversity and quality can still affect results.