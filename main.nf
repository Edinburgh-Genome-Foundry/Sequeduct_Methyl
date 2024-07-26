#!/usr/bin/env nextflow
// Copyright 2024 Edinburgh Genome Foundry, University of Edinburgh

// This file is part of Sequeduct Methyl.

// Sequeduct Methyl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

// Sequeduct Methyl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with Sequeduct Methyl. If not, see <https:www.gnu.org/licenses/>.

include { fileConverter } from "$projectDir/nextflow/pod5_converter.nf"
include { analysis_workflow } from "$projectDir/nextflow/analysis.nf"

workflow converter {
	Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true)
        .unique { row -> row['Barcode_dir'] } 
        .map { row ->
		def barcode_dir = row['Barcode_dir']
		def barcode_path = file("${params.fast5_dir}")
		return [barcode_dir, barcode_path]
        }
        .set { input_ch }

	fileConverter(input_ch)
}


workflow analysis {

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
	.map { row ->
		file(params.genbank_dir + '/' + row['Sample'] + '.gb')
	}
	.set { genbank_ch }	

	Channel.fromPath(params.param_sheet).set{ params_ch }

	analysis_workflow(reads_ch, genbank_ch, params_ch)

}
