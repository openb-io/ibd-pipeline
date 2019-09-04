#!/bin/bash

TO_VCF=/Users/rob/src/github.com/plantimals/2vcf/bin/2vcf

INPUT_LIST=$1

PEDIGREE=$2

REFERENCE=/Users/rob/data/science/markers/dbSNP/2vcf-v2.1.vcf.gz

WORKING_DIRECTORY=./tmp

BIN_DIRECTORY=./bin

#unique identifier for a pipeline run, signature of inputs
INPUT_MD5=`md5 -q ${INPUT_LIST}`

MERGED_VCF="${WORKING_DIRECTORY}/${INPUT_MD5}-merged.vcf.gz"

PHASED_VCF="${WORKING_DIRECTORY}/${INPUT_MD5}-merged-phased"

BEAGLE4_JAR="${BIN_DIRECTORY}/beagle.r1399.jar"

BEAGLE5_JAR="${BIN_DIRECTORY}/beagle.24Aug19.3e8.jar"

REFINED_IBD_JAR="${BIN_DIRECTORY}/refined-ibd.16May19.ad5.jar"

PHASED_IBD_OUT="${WORKING_DIRECTORY}/${INPUT_MD5}-merged-phased-ibd-called.vcf.gz"

REF_PANEL=/Users/rob/data/science/populations/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz

function indexVCF () {
  local VCF=$1 
  tabix ${VCF}
}

function getVCFName () {
  local SUBJECT=$1
  local SUBJECT_NAME=`basename ${SUBJECT} ".zip"`
  VCF_PATH="${WORKING_DIRECTORY}/${SUBJECT_NAME}.vcf.gz"
}

# convert incoming genotype array calls to vcf
function convert2VCF () {
  local SUBJECT=$1 
  getVCFName ${SUBJECT}
  echo ${SUBJECT}
  local CMD="${TO_VCF} conv 23andme --ref ${REFERENCE} --input ${SUBJECT} --output ${VCF_PATH} --fixAllos"
  eval ${CMD}
  indexVCF ${VCF_PATH}
}

# Stage 1 - convert input into VCF
function ingestion () {
  for SUBJECT in $(cat ${INPUT_LIST})
  do
    convert2VCF ${SUBJECT}
  done
}

# Stage 2 - merge VCFs
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

# Stage 3 - phasing
function phasingB4 () {
  CMD="java -Xmx10g -jar ${BEAGLE4_JAR} nthreads=6 gt=${MERGED_VCF} impute=false gprobs=false ped=${PEDIGREE} ibd=true ibdlod=4.0 out=${PHASED_VCF}"
  eval ${CMD}
}

function phasingB5 () {
  CMD="java -Xmx10g -jar ${BEAGLE5_JAR} nthreads=4 gt=${MERGED_VCF} impute=false out=${PHASED_VCF} ref=${REF_PANEL}"
  eval ${CMD}
}

function refinedIBD () {
  CMD="java -Xmx10g -jar ${REFINED_IBD_JAR} nthreads=6 gt=${PHASED_VCF}.vcf.gz.vcf.gz.vcf.gz out=${PHASED_IBD_OUT}"
  eval ${CMD}
}

# main pipeline

# run stage 1 - convert input to VCF

ingestion

# run stage 2 - merge VCF
merge

# run stage 3 - phasing
phasingB4
#phasingB5

#refinedIBD
