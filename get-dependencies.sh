#!/bin/bash

#fail if any command fails
set -e

mkdir bin 
mkdir tmp

cd bin 

wget https://github.com/plantimals/2vcf/releases/download/v0.4.1/2vcf_0.4.1_Darwin_amd64.tar.gz
tar -zxvf 2vcf_0.4.1_Darwin_amd64.tar.gz 2vcf
rm 2vcf_0.4.1_Darwin_amd64.tar.gz

wget http://openb.io/2vcf/2vcf-v2.1.vcf.gz

wget https://faculty.washington.edu/browning/beagle/beagle.r1399.jar

wget https://faculty.washington.edu/browning/beagle/beagle.24Aug19.3e8.jar

wget http://faculty.washington.edu/browning/refined-ibd/refined-ibd.16May19.ad5.jar


