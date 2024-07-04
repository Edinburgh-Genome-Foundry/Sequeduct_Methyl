<p align="center">
<img alt="Sequeduct Methyl logo" title="Sequeduct Methyl" src="images/logo.png" width="120">
</p>


# Sequeduct Methyl

Sequeduct Methyl is a extension to [Sequeduct](https://github.com/Edinburgh-Genome-Foundry/Sequeduct) as a stand-alone Nextflow analysis pipeline to validate cytosine methylations (5mC or 5hmC) in DNA constructs.

## Usage

### Setup

Install [Nextflow](https://www.nextflow.io/) and [Docker](https://www.docker.com/).

Pull the Nextflow pipeline:

```bash
nextflow pull edinburgh-genome-foundry/Sequeduct_Methyl -r main
```

To ensure optimal performance, please check that all package requirements are downloaded, and meet or exceed the versions specified in the `requirements.txt` file.

### Run

Change to the directory you wish to create your pipeline analysis output in. Copy (or link) all raw read POD5 directories from Oxford Nanopore Sequencing runs to this specified directory. All directories should specify different barcodes/indexes from the run, and should be contained within a single directory whose path is used for the `--pod5_dir` parameter when running the analysis command below. Also include the path to the directory containing the genbank reference files using `--genbank_dir`, sample sheet using `--sample_sheet` and parameter sheet using `--param_sheet`.

The following should be run on the command line:

```bash
nextflow run edinburgh-genome-foundry/Sequeduct_Methyl -r main \
    --pod5_dir 'path/to/pod5_pass' \
    --genbank_dir 'path/to/genbank_ref/dir' \
    --sample_sheet 'path/to/sample_sheet.csv' \
    --param_sheet 'path/to/parameter_sheet.csv' \
    --model_path '/full/path/to/dorado/model/directory' \ ###################
    --projectname "Methylation Project"
```

This command will create a directory of the results. Additionally, Nextflow automatically creates a 'work' directory to store all pipeline products. Ensure that you do not already have a directory named 'work' in this same location before running.

Examples of both the sample sheet and parameter sheet are available under the `examples` directory. Through the parameter sheet, the thresholds for % methylations can be specified. This refers to the % of reads that are modified for that position to be deemed methylated, or unmethylated. Any positions with a % of reads between these two specified modification cutoffs are considered undetermined. Alongside this in the parameter sheet, the methylases present in the bacterial sample can be specified, or their corresponding recognition nucleotide sequence/pattern. Multiple methylase enzymes can be specified separated by a space. For more detailed information, please consult [EpiJinn](https://github.com/Edinburgh-Genome-Foundry/EpiJinn).

### Details

The methylation modifications desired to be checked can be specified out of 5mC_5hmC, 4mC_5mC, or 6mA using the `--model` parameter when running the pipeline. This is defaulted to 5mC_5hmC. Optional methylation level thresholds parameters can also be specified, using `--mod_m_threshold` for the 5mC threshold, `--mod_h_threshold` for the 5hmC threshold, and `--mod_a_threshold` for the 6mA threshold. If not specified, these methylation confidence thresholds are taken to be the optimised thresholds as specified in the nextflow.config file. 

Additionally, alongside the final PDF file with detailed analysis output, the aligned BAM file and bedMethyl files are also automatically saved in the output directory. If you desire to not save these two extra files, set their corresponding parameters (`--aligned_bam` or `--bedMethyl` respectively) to 'false' when running the command below. If the additional FASTA reference file, sorted and indexed BAM files, or final report in html format are desired, then their corresponding parameters (`--fasta_ref`, `--indexed_bam`, or `--html_file` respectively) can be set to 'true' when running the command below.

The container image may update frequently with new updates in the software and packages utilised. It is advised to pull the newest version of Sequeduct Methyl before analysis.

## License = GPLv3+

Copyright 2024 Edinburgh Genome Foundry, University of Edinburgh.