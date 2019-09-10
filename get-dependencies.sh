#!/bin/bash

#fail if any command fails
set -e

mkdir bin 

cd bin 

# get and unpack 2vcf
wget https://github.com/plantimals/2vcf/releases/download/v0.5/2vcf_0.5_Linux_amd64.tar.gz
tar -zxvf 2vcf_0.5_Linux_amd64.tar.gz 2vcf
rm 2vcf_0.5_Linux_amd64.tar.gz

wget http://openb.io/2vcf/2vcf-v2.1.vcf.gz

wget https://faculty.washington.edu/browning/beagle/beagle.r1399.jar

wget https://faculty.washington.edu/browning/beagle/beagle.24Aug19.3e8.jar

wget http://faculty.washington.edu/browning/refined-ibd/refined-ibd.16May19.ad5.jar

# get and unpack relatedness_v2.py
#wget http://faculty.washington.edu/sguy/IBD_relatedness.tar
#tar -xf IBD_relatedness.tar

# get combined human genetic map
#wget http://openb.io/2vcf/plink.GRCh37.map.gz
#gunzip plink.GRCh37.map.gz