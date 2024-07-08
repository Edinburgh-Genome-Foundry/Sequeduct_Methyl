#!/usr/bin/env nextflow

process file_converter {
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
        converter(input_ch)
}