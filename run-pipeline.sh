#!/bin/bash

TO_VCF=/Users/rob/src/github.com/plantimals/2vcf/bin/2vcf

INPUT_LIST=$1

REFERENCE=/Users/rob/data/science/markers/dbSNP/2vcf-v2.1.vcf.gz

WORKING_DIRECTORY=./tmp

#unique identifier for a pipeline run, signature of inputs
INPUT_MD5=`md5 -q ${INPUT_LIST}`

MERGED_VCF="${WORKING_DIRECTORY}/${INPUT_MD5}-merged.vcf.gz"

function indexVCF () {
  local VCF=$1 
  tabix ${VCF}
}

function getVCFName () {
  local SUBJECT=$1
  local SUBJECT_NAME=`basename ${SUBJECT} ".zip"`
  VCF_PATH="${WORKING_DIRECTORY}/${SUBJECT_NAME}.vcf.gz"
}

# Stage 1 - convert input into VCF
function ingestion () {
  local SUBJECT=$1 
  getVCFName ${SUBJECT}
  local CMD="${TO_VCF} conv 23andme --ref ${REFERENCE} --input ${SUBJECT} --output ${VCF_PATH}"
  eval ${CMD}
  indexVCF ${VCF_PATH}
}

function merge () {
  local CMD="bcftools merge -O z -o ${MERGED_VCF}"
  for SUBJECT in $(cat ${INPUT_LIST})
  do 
    getVCFName ${SUBJECT}
    CMD="${CMD} ${VCF_PATH}"
  done
  eval "${CMD}"
  indexVCF ${MERGED_VCF}
}

# main pipeline

# run stage 1 - convert input to VCF
for SUBJECT in $(cat ${INPUT_LIST})
do
  echo "running ingestion(${SUBJECT})"
  ingestion ${SUBJECT}
done

#run stage 2 - merge VCF
merge

