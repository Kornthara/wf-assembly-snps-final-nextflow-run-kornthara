process PARSNP {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/parsnp:2.0.5--h4ac6f70_0':
        'biocontainers/parsnp:2.0.5--h4ac6f70_0' }"

    input:
    tuple val(meta), path(assemblies)
    path reference

    output:
    tuple val(meta), path("*.ggr")        , emit: ggr
    tuple val(meta), path("*.xmfa")       , emit: xmfa
    tuple val(meta), path("*.SNPs.fa.gz") , emit: snps
    tuple val(meta), path("*.tree")       , emit: tree
    tuple val(meta), path("*_summary.tsv"), emit: summary
    path "versions.yml"                   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def max_partition = task.ext.max_partition_size ?: 15000000
    
    """
    # Create genomes directory and copy assemblies
    mkdir -p genomes
    for assembly in ${assemblies}; do
        if [[ -d "\$assembly" ]]; then
            # If it's a directory, copy recursively
            cp -r "\$assembly"/* genomes/ 2>/dev/null || cp -r "\$assembly" genomes/
        elif [[ -f "\$assembly" ]]; then
            # If it's a file, copy normally
            cp "\$assembly" genomes/
        else
            echo "Warning: \$assembly is neither a file nor directory"
        fi
    done

    # Clean reference file name to avoid parsnp issues with hyphens
    ref_clean=\$(basename ${reference} | sed 's/-/_/g')
    if [[ -d "${reference}" ]]; then
        # If reference is a directory, find the first FASTA file
        ref_file=\$(find ${reference} -name "*.fasta" -o -name "*.fa" -o -name "*.fna" | head -1)
        if [[ -n "\$ref_file" ]]; then
            cp "\$ref_file" \$ref_clean
        else
            echo "Error: No FASTA files found in reference directory ${reference}"
            exit 1
        fi
    else
        # If reference is a file, copy normally
        cp ${reference} \$ref_clean
    fi

    # Verify we have a valid reference file
    if [[ ! -f "\$ref_clean" ]]; then
        echo "Error: Reference file \$ref_clean not found or not accessible"
        exit 1
    fi

    # Also clean deflines in reference to avoid parsnp v1.2+ issues
    sed -i 's/-/_/g' \$ref_clean

    # Log input information for debugging
    echo "=== PARSNP Input Information ==="
    echo "Reference file: \$ref_clean"
    echo "Reference file size: \$(stat -c%s \$ref_clean 2>/dev/null || echo 'unknown')"
    echo "Number of assembly files: \$(ls genomes/ | wc -l)"
    echo "Assembly files:"
    ls -la genomes/
    echo "Available CPUs: ${task.cpus}"
    echo "Available memory: ${task.memory}"
    echo "================================"

    # Run parsnp with proper error handling
    parsnp \\
        --sequences genomes/ \\
        --reference \$ref_clean \\
        --output-dir parsnp_output \\
        --verbose \\
        --use-fasttree \\
        --curated \\
        --threads ${task.cpus} \\
        --max-partition-size ${max_partition} \\
        ${args}
    
    # Check if parsnp succeeded
    if [[ \$? -ne 0 ]]; then
        echo "=== PARSNP FAILED - Diagnostic Information ==="
        echo "Exit code: \$?"
        echo "Reference file: \$ref_clean"
        echo "Reference file exists: \$(test -f \$ref_clean && echo 'YES' || echo 'NO')"
        echo "Reference file size: \$(stat -c%s \$ref_clean 2>/dev/null || echo 'unknown')"
        echo "Number of assemblies: \$(ls genomes/ | wc -l)"
        echo "Assembly files:"
        ls -la genomes/
        echo "Genomes directory contents:"
        find genomes/ -type f -name "*.fa*" -o -name "*.fna" | head -10
        echo "Disk space:"
        df -h .
        echo "Memory usage:"
        free -h 2>/dev/null || echo "Memory info not available"
        echo "=============================================="
        exit 1
    fi

    # Move and rename output files
    mv parsnp_output/parsnp.ggr ${prefix}.ggr
    mv parsnp_output/parsnp.xmfa ${prefix}.xmfa
    mv parsnp_output/parsnp.snps.mblocks ${prefix}.SNPs.fa

    # Handle tree file based on method used
    if [[ -f parsnp_output/log/fasttree.out ]]; then
        mv parsnp_output/log/fasttree.out ${prefix}.tree
    elif [[ -f parsnp_output/parsnp.tree ]]; then
        mv parsnp_output/parsnp.tree ${prefix}.tree
    else
        echo "Warning: No tree file found"
        touch ${prefix}.tree
    fi

    # Create summary file
    echo -e "Sample name\\tQC step\\tOutcome (Pass/Fail)" > ${prefix}_summary.tsv
    
    for file in ${prefix}.ggr ${prefix}.xmfa ${prefix}.SNPs.fa; do
        if [[ -s "\$file" && \$(stat -c%s "\$file") -gt 1000 ]]; then
            echo -e "NaN\\t\${file} Output File\\tPASS" >> ${prefix}_summary.tsv
        else
            echo -e "NaN\\t\${file} Output File\\tFAIL" >> ${prefix}_summary.tsv
        fi
    done

    # Clean up reference suffix if present
    if [[ \$(grep -c '\\.ref' ${prefix}.tree 2>/dev/null || echo 0) -eq 1 ]]; then
        sed -i 's/\\.ref//g' ${prefix}.tree ${prefix}.SNPs.fa
    fi

    # Compress SNPs file
    gzip -9f ${prefix}.SNPs.fa

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        parsnp: \$(parsnp --version 2>&1 | grep -o 'Parsnp [0-9.]*' | sed 's/Parsnp //')
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.ggr
    touch ${prefix}.xmfa
    touch ${prefix}.SNPs.fa.gz
    touch ${prefix}.tree
    touch ${prefix}_summary.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        parsnp: \$(parsnp --version 2>&1 | grep -o 'Parsnp [0-9.]*' | sed 's/Parsnp //' || echo "2.0.5")
    END_VERSIONS
    """
}