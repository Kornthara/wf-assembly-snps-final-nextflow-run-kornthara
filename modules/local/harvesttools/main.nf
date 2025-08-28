process HARVESTTOOLS {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/harvesttools:1.3--h4ac6f70_0':
        'biocontainers/harvesttools:1.3--h4ac6f70_0' }"

    input:
    tuple val(meta), path(ggr)

    output:
    tuple val(meta), path("*.fasta"), emit: fasta
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    harvesttools \\
        -i ${ggr} \\
        -M ${prefix}.fasta \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        harvesttools: \$(harvesttools --version 2>&1 | grep -o 'HarvestTools [0-9.]*' | sed 's/HarvestTools //' || echo "1.3")
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        harvesttools: \$(harvesttools --version 2>&1 | grep -o 'HarvestTools [0-9.]*' | sed 's/HarvestTools //' || echo "1.3")
    END_VERSIONS
    """
}