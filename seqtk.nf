#!/usr/bin/env nextflow

params.files = "/projects/b1059/data/fastq/WI/rna/BZ-RNA-MZ/BZ_data/RNA/170112_K00242_0168_AHHF52BBXX-EA-RS8/*"

log.info """\
               Subsample + Kallisto
         ===================================
         files         : ${params.files}
         
         """
         .stripIndent()

file_name = Channel
                .fromPath( params.files )
                //.map { file -> tuple(file.baseName, file) }


replicates = Channel.from ( 1..10 )


num = Channel.from( 1000000, 5000000, 10000000, 15000000, 20000000, 25000000, 30000000, 35000000 )

process seqtk {

	publishDir "seqtk_nf_results", mode: 'copy'

	tag "${r}_${i}_${seq_file}"
	
	input:
	   each file(seq_file) from file_name
	   each r from replicates
	   each i from num

	output:
	   file "${r}_${i}_${seq_file}"

	script:
	"""
	seed=\$((1 + RANDOM % 100000))
	seqtk sample -s\${seed} ${seq_file} ${i} | gzip > ${r}_${i}_${seq_file}
	"""
}
