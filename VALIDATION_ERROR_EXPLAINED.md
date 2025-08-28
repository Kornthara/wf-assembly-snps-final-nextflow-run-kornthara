# Understanding the Validation Error

## 🚨 Your Error Message:
```
ERROR ~ Validation of pipeline parameters failed!
-- Check script 'subworkflows/nf-core/utils_nfschema_plugin/main.nf' at line: 39 or see '.nextflow.log' file for details
The following invalid input values have been detected:
* Missing required parameter(s): input, outdir
```

## 🔍 What's Happening:

The error occurs at **line 39** in `subworkflows/nf-core/utils_nfschema_plugin/main.nf`, which contains:

```groovy
validateParameters()
```

This is the **nf-schema plugin** doing its job correctly - it's validating that all required parameters are provided before the pipeline starts running.

## 📋 The Validation Process:

1. **Pipeline starts** → Nextflow loads the configuration
2. **nf-schema plugin activates** → Checks the `nextflow_schema.json` file
3. **Parameter validation** → Ensures required parameters are provided
4. **Validation fails** → Because `input` and `outdir` are missing
5. **Pipeline stops** → With the error message you see

## ✅ **THE FIX** (This is NOT a bug - it's working correctly):

You need to provide the required parameters when running the pipeline:

### ❌ What you ran (incorrect):
```bash
nextflow run . -profile local_12core
```

### ✅ What you need to run (correct):
```bash
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

## 🎯 Why This Validation Exists:

The validation is **intentional and beneficial** because it:
- **Prevents wasted time** - Stops the pipeline before it starts processing
- **Provides clear error messages** - Tells you exactly what's missing
- **Ensures data integrity** - Makes sure you specify where input comes from and output goes
- **Follows nf-core standards** - All nf-core pipelines have this validation

## 📊 Required Parameters:

According to the schema, these parameters are **mandatory**:

1. **`--input`**: Path to your samplesheet CSV file
2. **`--outdir`**: Directory where results will be saved

## 🚀 Complete Working Examples:

### Basic run:
```bash
cd nf-core-assemblysnps
nextflow run . --input samplesheet.csv --outdir results -profile local_12core
```

### With additional options:
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    --max_memory 64.GB \
    --max_cpus 12 \
    -profile local_12core
```

### Resume a failed run:
```bash
cd nf-core-assemblysnps
nextflow run . \
    --input samplesheet.csv \
    --outdir results \
    -profile local_12core \
    -resume
```

## 🔧 Troubleshooting Steps:

### 1. Verify you have a samplesheet:
```bash
ls -la samplesheet.csv
cat samplesheet.csv
```

### 2. Check the samplesheet format:
```csv
sample,assembly
sample1,path/to/assembly1.fasta
sample2,path/to/assembly2.fasta
```

### 3. Verify assembly files exist:
```bash
# Check if files in samplesheet exist
for file in $(cut -d',' -f2 samplesheet.csv | tail -n +2); do
    ls -la "$file"
done
```

### 4. Test with help to verify syntax:
```bash
nextflow run . --input samplesheet.csv --outdir results --help
```

## 📝 Summary:

**This is NOT a bug or error in the pipeline code.** The validation is working exactly as designed. You simply need to provide the required `--input` and `--outdir` parameters when running the pipeline.

The error message is actually **helpful** because it:
- Stops you from running an incomplete command
- Tells you exactly what's missing
- Saves you time by failing fast

Just add the missing parameters and your pipeline will run successfully!