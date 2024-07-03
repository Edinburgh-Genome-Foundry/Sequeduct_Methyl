#!/usr/bin/env nextflow

include { analysis_workflow } from "$projectDir/nextflow/analysis.nf"

workflow {

    Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true)
        .unique { row -> [row['Sample'], row['Barcode_dir']] } 
        .map { row ->
			def sample_name = row['Sample']
            def barcode_name = row['Barcode_dir']
			def genbank_path = file("${params.genbank_dir}/${sample_name}.gb")
            def barcode_path = file("${params.pod5_dir}/${barcode_name}")
            return [sample_name, barcode_name, genbank_path, barcode_path]
            }
        .set { reads_ch }

	Channel
		.fromPath(params.sample_sheet)
		.splitCsv(header: true)
		.unique { row -> row['Sample'] }
		.map { row -> file(params.genbank_dir + '/' + row['Sample'] + '.gb') }
		.set { genbank_ch }	

	Channel.fromPath(params.param_sheet).set{ params_ch }

    analysis_workflow(reads_ch, genbank_ch, params_ch)

}