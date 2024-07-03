#!/usr/bin/env nextflow

process runDorado {
	publishDir "data/output/docker/${barcode}", mode: "copy", pattern: "*.bam"
	
	input:
		tuple path(ref_path), path(barcode)

	output:
		tuple path(barcode), path(aligned_bam)

	script:
		aligned_bam = "${barcode}_aln.bam"

		"""
		dorado basecaller /opt/dna_r10.4.1_e8.2_400bps_hac@v5.0.0 ${barcode} --reference ${ref_path} --verbose --batchsize 64 --device cuda:all --modified-bases 5mC_5hmC > ${aligned_bam}
		"""
}

process alignReads {
	publishDir "data/output/docker/${barcode}", mode: "copy", pattern: "*.bam"
	publishDir "data/output/docker/${barcode}", mode: "copy", pattern: "*.bai"

	input:
		tuple path(barcode), path(aligned_bam)

	output:
		tuple path(barcode), path(sorted_bam), path(sorted_indexed_bam)

	script:
		sorted_bam = barcode + "_aln_sorted.bam"
		sorted_indexed_bam = sorted_bam + ".bai"

		"""
		samtools sort ${aligned_bam} -o ${sorted_bam}
		
		samtools index ${sorted_bam} ${sorted_indexed_bam}
		"""
}

process summariseReads {
	publishDir "data/output/docker/${barcode}", mode: "copy", pattern: "*.bed"

	input:
		tuple path(barcode), path(sorted_bam), path(indexed_bai)

	output:
		tuple path(barcode), path(bedMethyl_file)

	script:
		bedMethyl_file = sorted_bam.baseName + ".bed"

		"""
		modkit pileup ${sorted_bam} ${bedMethyl_file} --log-filepath pileup_aln.log
		"""
}

workflow {
	main:
		Channel
            .fromPath(params.sample_sheet)
            .splitCsv(header: true)
            .unique { row -> [row['Sample'], row['Barcode_dir']] } 
            .map { row ->
				def sample_name = row['Sample']
                def barcode_dir = row['Barcode_dir']
				def sample_ref_path = file("${params.ref_fasta_dir}/${sample_name}.fa")
                def barcode_path = file("${params.pod5_dir}/${barcode_dir}")
                return [sample_ref_path, barcode_path]
            }
            .set { reads_ch }

		runDorado(reads_ch)
		alignReads(runDorado.out)
		summariseReads(alignReads.out)
}
