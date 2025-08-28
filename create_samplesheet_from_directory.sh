#!/bin/bash

# Script to create a samplesheet from an assembly directory
# This fixes the validation error you encountered

set -e

# Function to display usage
usage() {
    echo "Usage: $0 <assembly_directory> [output_samplesheet.csv]"
    echo ""
    echo "This script creates a proper samplesheet CSV file from a directory containing assembly files."
    echo ""
    echo "Arguments:"
    echo "  assembly_directory    : Path to directory containing assembly files (.fasta, .fa, .fna)"
    echo "  output_samplesheet.csv: Output CSV file (default: samplesheet.csv)"
    echo ""
    echo "Example:"
    echo "  $0 /home/kornthara/wf-paired-end-illumina-assembly/BP_Fastq_05_Jun_2025/results/Assembly"
    echo ""
    echo "This will create a samplesheet.csv file that you can use with:"
    echo "  nextflow run . --input samplesheet.csv --outdir results -profile local_12core"
    exit 1
}

# Check arguments
if [[ $# -lt 1 ]]; then
    echo "Error: Assembly directory not specified"
    usage
fi

ASSEMBLY_DIR="$1"
OUTPUT_CSV="${2:-samplesheet.csv}"

# Check if directory exists
if [[ ! -d "$ASSEMBLY_DIR" ]]; then
    echo "Error: Directory '$ASSEMBLY_DIR' does not exist"
    exit 1
fi

# Find assembly files
echo "Searching for assembly files in: $ASSEMBLY_DIR"
ASSEMBLY_FILES=($(find "$ASSEMBLY_DIR" -type f \( -name "*.fasta" -o -name "*.fa" -o -name "*.fna" \) | sort))

if [[ ${#ASSEMBLY_FILES[@]} -eq 0 ]]; then
    echo "Error: No assembly files found in '$ASSEMBLY_DIR'"
    echo "Looking for files with extensions: .fasta, .fa, .fna"
    echo ""
    echo "Directory contents:"
    ls -la "$ASSEMBLY_DIR"
    exit 1
fi

echo "Found ${#ASSEMBLY_FILES[@]} assembly files"

# Create samplesheet header
echo "sample,assembly" > "$OUTPUT_CSV"

# Add each assembly file to the samplesheet
for i in "${!ASSEMBLY_FILES[@]}"; do
    file="${ASSEMBLY_FILES[$i]}"
    # Extract sample name from filename (remove path and extension)
    sample_name=$(basename "$file" | sed 's/\.[^.]*$//')
    # Clean sample name (remove special characters, replace with underscores)
    sample_name=$(echo "$sample_name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
    
    echo "${sample_name},${file}" >> "$OUTPUT_CSV"
    echo "Added: $sample_name -> $file"
done

echo ""
echo "✅ Samplesheet created: $OUTPUT_CSV"
echo ""
echo "Contents:"
echo "----------------------------------------"
cat "$OUTPUT_CSV"
echo "----------------------------------------"
echo ""
echo "Now you can run the pipeline with:"
echo "  nextflow run . --input $OUTPUT_CSV --outdir results -profile local_12core"
echo ""
echo "Or if you want to specify resource limits:"
echo "  nextflow run . --input $OUTPUT_CSV --outdir results --max_memory 64.GB --max_cpus 12 -profile local_12core"