#!/usr/bin/env python3

import epijinn
import sys

sample_sheet_file = sys.argv[1]
parameter_sheet_file = sys.argv[2]
pdf_file = sys.argv[3]
html_file = sys.argv[4]

bedmethylitemgroup = epijinn.read_sample_sheet(
    sample_sheet = sample_sheet_file,
    genbank_dir = "",
    bedmethyl_dir = "",
    parameter_sheet = parameter_sheet_file,)
bedmethylitemgroup.perform_all_analysis_in_bedmethylitemgroup()
epijinn.write_bedmethylitemgroup_report(bedmethylitemgroup=bedmethylitemgroup, pdf_file=pdf_file, html_file=html_file)