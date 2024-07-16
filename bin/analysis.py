#!/usr/bin/env python3
# Copyright 2024 Edinburgh Genome Foundry, University of Edinburgh
#
# This file is part of Sequeduct Methyl.
#
# Sequeduct Methyl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# Sequeduct Methyl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with Sequeduct Methyl. If not, see <https:www.gnu.org/licenses/>.

import epijinn
import sys
import resource

# Set 5 times the default. This is to avoid a problem during PDF build and may be revised later.
resource.setrlimit(resource.RLIMIT_STACK, (41943040, -1))
sys.setrecursionlimit(5000)

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