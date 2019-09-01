#!/bin/bash

echo "start"

# Stage 1 - convert input into VCF
function ingestion () {
  SUBJECT=$1
  SUBJECT_NAME=`basename ${SUBJECT} ".zip"`
  SUBJECT_VCF="${WORKING_DIRECTORY}/${SUBJECT_NAME}.vcf.gz"
  CMD="${TO_VCF} conv 23andme --ref ${REFERENCE} --input ${SUBJECT} --output ${SUBJECT_VCF}"
  echo "about to run: ${CMD}"
  eval ${CMD}
}

echo "function defined"

TO_VCF=/Users/rob/src/github.com/plantimals/2vcf/bin/2vcf

INPUT_LIST=$1

REFERENCE=/Users/rob/data/science/markers/dbSNP/2vcf-v2.1.vcf.gz

WORKING_DIRECTORY=./tmp/

echo "constants setup"

for SUBJECT in $(cat ${INPUT_LIST})
do
  echo "running ingestion(${SUBJECT})"
  ingestion ${SUBJECT}
done
