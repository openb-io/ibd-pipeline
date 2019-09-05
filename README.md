# Overview

from [takir.org](https://takir.org/2019/07/06/genetic-genealogical-methods-used-to-identify-african-american-diaspora-relatives-in-the-study-of-family-identity-among-ghanaian-members-of-the-kassena-ethnic-group-part-2/):
> By first using family-based phasing to order the child’s allele assignments and to identify segments shared by both the child and a parent, this ensures that the DNA segment being compared to other profiles of unknown relatedness to the child is truly a segment that was inherited by the child from a parent (i.e., IBD). Algorithms provided by GEDmatch enables the general public to create phased genetic profiles and then to conduct IBD segment sharing matching with other users in their database. IBD segment sharing among two target child profiles and one of each of their parents (i.e., among two parent-child dyads) infers that the segment was inherited from a shared ancestor and that the two target persons (and the matching parents) are related.



# IBD Calling Pipeline

1) Receive input files - I'll receive input files from 23andMe, AncestryDNA, or the lab. I'm not sure how the lab will format the file, but they are most likely using the Illumina GenomeStudio software. GenomeStudio has a PLINK plugin so let's assume that it'll be in PLINK format and need to be converted to VCF with PLINK/SEQ. (not etched in stone). The lab is using the H3A chip.

2) Convert files to VCF - Here is where we run into the issue of SNP selection. H3A has the larger SNP selection but it may miss some that's found in AncestryDNA or 23andMe. We would need to make use of all available markers for IBD later. And I don't impute. Also, we ran into an issue of formatting (for bcftools) that we corrected like this:

forfiles /p Data /m *.vcf.gz /c "cmd /c gzip -d @file"  
forfiles /p Data /m *.vcf /c "cmd /c sed -i 's/GT,Number=.,Type=Integer/GT,Number=.,Type=String/g' @file"
forfiles /p Data /m *.vcf /c "cmd /c bgzip @file"

3) We then index and merge into single VCF file for use in beagle -

forfiles /p Data /m *.vcf.gz /c "cmd /c bcftools.exe index @file"
bcftools merge -O z -o Results\MergedSamples.vcf.gz Data/*.vcf.gz

4) Then we phase the samples using Beagle 4.0. - When I have the trios (father-mother-offspring) or duos (parent-offspring) samples, I prefer the option of family-based phasing using a PED file with family information. Beagle also provide the option of specifying a reference panel which I planned to use but I haven't yet. They also the option of using a MAP file which is important for IBD detection. They provide a link to down the MAP files. Without specifying a map file, command line is:

java -Xmx3g -jar beagle.r1399.jar gt=Results\MergedSamples.vcf.gz gprobs=false impute=false ped=StorageZipFiles\pedigree.ped ibd=true ibdlod=4.0 out=Results\PhasedB4ped.gt 

5) Beagle 4.0 has the ped argument for family-based phasing whereas the latest version of Beagle does not. Beagle 5.0 does computational phasing. Additionally, if using Beagle 5.0 (or now 5.1), IBD detection is done separately in Refined IBD. In Beagle 4.0, Refined IBD is included and used with the ped argument. I like to run both paths and compare the results of 4.0 and 5.0 though family-based phasing is most accurate.

java -Xmx3g -jar beagle.12Jul19.0df.jar gt=Results\MergedSamples.vcf.gz impute=false out=Results\PhasedB5.gt

java -Xmx3g -jar refined-ibd.16May19.ad5.jar gt=Results\PhasedB5.gt.vcf.gz lod=4.0 length=2.0 out=Results\IBDwB5

6) Merge segments across gaps of 0.6 cMs or less. So if taking the IBD output from Beagle 4.0, the command line would be something like:

cat Results\PhasedB4ped.gt.ibd | java -jar merge-ibd-segments.16May19.ad5.jar Results\MergedSamples.vcf.gz map=plink.GRCh38.map\plink.GRCh38xX.map 0.6 1 > B4pedGapsFilled.ibd 

7) And finally, the relatedness calculation in python:

cat Results\PhasedB4ped.gt.ibd | python relatedness_v1.py plink.GRCh38.map\plink.GRCh38xX.map 2 vcfhead=simdata.vcf_header lower nofill > Results\PhasedB4ped.lower.relatedness.mincm2.nofillhead

8) But I would like to see IBD results similar to GEDmatch with chromosome number, start position, stop position, segment length in cMs, and number of SNPs. And then total shared, and largest single segment.
