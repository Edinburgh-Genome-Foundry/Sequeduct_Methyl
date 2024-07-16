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

import sys

genbank_path = sys.argv[1]  # skip first filename
sample = sys.argv[2]
sample_fasta = sys.argv[3]

from Bio import SeqIO

# Genbank in
record = SeqIO.read(genbank_path, "genbank")
record.id = sample
# FASTA out
with open(sample_fasta, "w") as output_handle:
    SeqIO.write(record, output_handle, "fasta")
