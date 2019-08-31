#!/bin/bash

INPUT=$1

REFERENCE=/path/to/ref.vcf.gz

VCF_INPUT=/path/to/converted.vcf.gz

# Stage 1 - convert input into VCF

./2vcf conv h3africa --ref $REFERENCE --input $INPUT --output $VCF_INPUT

# Stage 2 - phasing

java -Xmx10g -jar beagle.24Aug19.3e8.jar -gt=$VCF_INPUT