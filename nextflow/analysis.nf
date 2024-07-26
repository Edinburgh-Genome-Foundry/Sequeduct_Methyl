#!/usr/bin/env nextflow
// Copyright 2024 Edinburgh Genome Foundry, University of Edinburgh

// This file is part of Sequeduct Methyl.

// Sequeduct Methyl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

// Sequeduct Methyl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with Sequeduct Methyl. If not, see <https:www.gnu.org/licenses/>.

process convertGenbank {
	publishDir "output/${barcode}", mode: "copy", pattern: "*.fa", enabled: params.fasta_ref

	input:
        	tuple val(sample_name), val(barcode), path(genbank_path), path(barcode_path)

	output:
        	tuple val(sample_name), val(barcode), path(barcode_path), path(sample_fasta)

	script:
        	sample_fasta = sample_name + ".fa"

        	"""
        	convert_genbank.py "${genbank_path}" "${sample_name}" "${sample_fasta}"
        	"""
}

process runDorado {
	publishDir "output/${barcode}", mode: "copy", pattern: "*.bam", enabled: params.aligned_bam

	input:
		tuple val(sample_name), val(barcode), path(barcode_path), path(sample_fasta)

	output:
		tuple val(barcode), path(aligned_bam), val(sample_name)

	script:
		aligned_bam = "${barcode}_aln.bam"
		
		"""
		dorado basecaller ${params.model_path}/dna_r10.4.1_e8.2_400bps_hac@v5.0.0 ${barcode_path} --reference ${sample_fasta} --verbose --batchsize ${params.dorado_batchsize} --device ${params.dorado_device} --modified-bases ${params.model} > ${aligned_bam}
		"""
}

process indexReads {
	publishDir "output/${barcode}", mode: "copy", pattern: "*.bam", enabled: params.indexed_bam
	publishDir "output/${barcode}", mode: "copy", pattern: "*.bai", enabled: params.indexed_bam

	input:
		tuple val(barcode), path(aligned_bam), val(sample_name)

	output:
		tuple val(barcode), path(sorted_bam), path(sorted_indexed_bam), val(sample_name)

	script:
		sorted_bam = barcode + "_aln_sorted.bam"
		sorted_indexed_bam = sorted_bam + ".bai"

		"""
		samtools sort ${aligned_bam} -o ${sorted_bam}
		samtools index ${sorted_bam} ${sorted_indexed_bam}
		"""
}

process summariseReads {
	publishDir "output/${barcode}", mode: "copy", pattern: "*.bed", enabled: params.bedMethyl

	input:
		tuple val(barcode), path(sorted_bam), path(indexed_bai), val(sample_name)

	output:
		tuple val(sample_name), val(barcode), path(bedMethyl_file)

	script:
		bedMethyl_file = "${barcode}_${sample_name}.bed"

		"""
		modkit pileup ${sorted_bam} ${bedMethyl_file} --log-filepath pileup_aln.log --mod-thresholds m:${params.mod_5mC_threshold} --mod-thresholds h:${params.mod_5hmC_threshold} --mod-thresholds a:${params.mod_6mA_threshold} --mod-thresholds 21839:${params.mod_4mC_threshold}
		"""
}

process writeCSV {

	input:
		tuple val(sample_name), val(barcode), path(bedMethyl_file)

	output:
		path samplesheet_csv, emit: samplesheet_csv_ch
		path bedMethyl_file, emit: bedMethyl_file_ch

	script:
		samplesheet_csv = "samples.csv"

		"""
		echo "${params.projectname},${barcode},${sample_name},${bedMethyl_file}" >> ${samplesheet_csv}
		"""

}

process runEpiJinn {
	publishDir "output", mode: "copy", pattern: "*.pdf"
	publishDir "output", mode: "copy", pattern: "*.html", enabled: params.html_file

	input:
		path genbank_path
		path bedMethyl_file
		path samplesheet_csv
		path param_sheet

	output:
		tuple path(samplesheet_csv), path(pdf_file), path(html_file)

	script:
		pdf_file = "EpiJinn_report.pdf"
		html_file = "EpiJinn_report.html"

		"""
		analysis.py ${samplesheet_csv} ${param_sheet} ${pdf_file} ${html_file}
		"""
}

workflow analysis_workflow {
	
	take:
		reads_ch
		genbank_ch
		params_ch
	
	main:
		convertGenbank(reads_ch)
		runDorado(convertGenbank.out)
		indexReads(runDorado.out)
		summariseReads(indexReads.out)
		writeCSV(summariseReads.out)
		runEpiJinn(genbank_ch.collect(), writeCSV.out.bedMethyl_file_ch.collect(), writeCSV.out.samplesheet_csv_ch.collectFile(), params_ch)
}
