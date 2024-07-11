# Sequeduct Methyl Demonstration

This outlines a demonstration of the pipeline Sequeduct Methyl with example input data, as well as an interpretation of the outputs. 

All extra files required for a demonstration run of Sequeduct Methyl are available under the directory `demo`, including sample POD5 data and the reference GenBank-format file.

### Run

Sequeduct Methyl requires four input files in total. The `pod5_dir` and GenBank-format reference file from the `demo` directory should be downloaded in a directory you wish to run the pipeline from. Additionally, download the `sample_sheet.csv` and `param_sheet.csv` from the `examples` directory, and then the following can be run. Note that `--model_path` requires the full path to the basecalling model `dna_r10.4.1_e8.2_400bps_hac@v5.0.0` by [Dorado](https://github.com/nanoporetech/dorado).

```bash
nextflow run edinburgh-genome-foundry/Sequeduct_Methyl -r main -entry analysis \
    --pod5_dir './pod5_pass' \
    --genbank_dir './genbank' \
    --sample_sheet './sample_sheet.csv' \
    --param_sheet './parameter_sheet.csv' \
    --model_path '/full/path/to/dorado/model/directory' \
    --projectname "Methylation Project Demo"
```

This demo run uses the 5mC_5hmC Dorado basecaller model that identifies 5mC and 5hmC cytosine methylations. The final PDF report identifies DNA regions containing the patterns of the methylases EcoKDcm (CCWGG) and BamHI (GGATCC).

Results files are saved in a new directory in your current working directory named `output`. By default, these output files include the aligned BAM file, bedMethyl table files, and final PDF report. The PDF report visualises the methylated position for each methylase pattern per sample.