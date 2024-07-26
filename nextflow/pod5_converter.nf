#!/usr/bin/env nextflow
// Copyright 2024 Edinburgh Genome Foundry, University of Edinburgh

// This file is part of Sequeduct Methyl.

// Sequeduct Methyl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

// Sequeduct Methyl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with Sequeduct Methyl. If not, see <https:www.gnu.org/licenses/>.

process fileConverter {
    publishDir "${barcode_path}/pod5_pass", mode: "copy", pattern: "*.pod5"

    input:
        tuple val(barcode), path(barcode_path)

    output:
        path pod5_output

    script:
        pod5_output = "${barcode_path}/pod5_pass/"
        """
        pod5 convert fast5 ${barcode_path}/${barcode}/*.fast5 --output ${pod5_output} --one-to-one ${barcode_path}/
        """
}

workflow {
    take:
        input_ch
    
    main:
        fileConverter(input_ch)
}
