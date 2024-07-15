# Sequeduct Methyl Demonstration

This outlines a demonstration of the pipeline Sequeduct Methyl with example input data, as well as an interpretation of the outputs. 

All extra files required for a demonstration run of Sequeduct Methyl are available under the directory `demo`, including sample [POD5 data](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/tree/main/demo/pod5_pass) and the reference [GenBank-format file](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/blob/main/demo/genbank/EGF_met_1.gb).

## Run

Sequeduct Methyl requires four input files in total. The `pod5_dir` and GenBank-format reference file from the [demo](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/tree/main/demo) directory should be downloaded in a directory you wish to run the pipeline from. Additionally, download the `sample_sheet.csv` and `param_sheet.csv` from the [sheets](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/tree/main/demo/sheets) directory, and then the following can be run. Note that `--model_path` requires the full path to the basecalling model `dna_r10.4.1_e8.2_400bps_hac@v5.0.0` by [Dorado](https://github.com/nanoporetech/dorado).

```bash
nextflow run edinburgh-genome-foundry/Sequeduct_Methyl -r main -entry analysis \
    --pod5_dir './pod5_pass' \
    --genbank_dir './genbank' \
    --sample_sheet './sheets/sample_sheet.csv' \
    --param_sheet './sheets/parameter_sheet.csv' \
    --model_path '/full/path/to/dorado/model/directory' \
    --projectname "Methylation Project Demo"
```

This demo run uses the 5mC_5hmC Dorado basecaller model that identifies 5mC and 5hmC cytosine methylations. The final PDF report identifies DNA regions containing the patterns of the methylases EcoKDcm (CCWGG) and BamHI (GGATCC).

Results files are saved in a new directory in your current working directory named `output`. By default, these output files include the aligned BAM file, bedMethyl table files, and final PDF report. The PDF report visualises the methylated position for each methylase pattern per sample.

## Setting Additional Parameters

Besides the parameters specified above, there are additional optional parameters that can be set by the user. The full list of default parameters can be found in the [nextflow.config](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/blob/main/nextflow.config) file.

* `--mod_m_threshold`, `--mod_h_threshold`, and `--mod_a_threshold` correspond to the confidence score threshold of each read to be classified as methylated for 5mC, 5hmC, or 6mA respectively.

* `--parallel_runs` controls the number of samples that are run in parallel for the runDorado step in the [analysis.nf](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/blob/main/nextflow/analysis.nf) Nextflow pipeline. If you encounter an issue regarding CPU/GPU memory running at capacity, consider decreasing this value. If your device can handle running many samples in parallel, increase this value to speed up the process.

* `--dorado_batchsize` refers to the batch size used when carrying out Dorado, and can be adjusted depending on your CPU/GPU memory. Higher RAM can deal with a higher batch size, so increasing this value can speed up the process. This is set to a default to prevent Dorado from testing each batch size to select an appropriate one.

* `--dorado_device` refers to the GPU utilised by Dorado. This is set by default to cuda:0, meaning it will run on the first CUDA-enabled GPU available. Modify this parameter to select the RAM device available on your system.

* `--fasta_ref`, `--indexed_bam`, and `--html_file` can be set to "true" if you wish to save the FASTA reference file generated from the reference GenBank-format file, or the indexed BAM file, or the final HTML report respectively.

* `--aligned_bam` and `--bedMethyl` can be set to "false" if you do not wish to save the aligned BAM file or bedMethyl table files respectively.

Moreover, the [parameter sheet](https://github.com/Edinburgh-Genome-Foundry/Sequeduct_Methyl/blob/main/examples/param_sheet.csv) included as input through the `--param_sheet` parameter is utilised by the python package [EpiJinn](https://github.com/Edinburgh-Genome-Foundry/EpiJinn/tree/main). It includes the methylation threshold for the proportion of all reads at each position required to classify the position as methylated (above `methylated_cutoff`), unmethylated (below `unmethylated_cutoff`), or undecided (between `methylated_cutoff` and `unmethylated_cutoff`). These can be altered to be more stringent or lenient as you desire. The `methylases` parameter contains the methylases present in your bacterial sample, through which methylations present in these methylase patterns will be identified and flagged. This parameter can take one or multiple methylases separated by a space.