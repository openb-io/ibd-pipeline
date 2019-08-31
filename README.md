# Overview

from [takir.org](https://takir.org/2019/07/06/genetic-genealogical-methods-used-to-identify-african-american-diaspora-relatives-in-the-study-of-family-identity-among-ghanaian-members-of-the-kassena-ethnic-group-part-2/):
> By first using family-based phasing to order the child’s allele assignments and to identify segments shared by both the child and a parent, this ensures that the DNA segment being compared to other profiles of unknown relatedness to the child is truly a segment that was inherited by the child from a parent (i.e., IBD). Algorithms provided by GEDmatch enables the general public to create phased genetic profiles and then to conduct IBD segment sharing matching with other users in their database. IBD segment sharing among two target child profiles and one of each of their parents (i.e., among two parent-child dyads) infers that the segment was inherited from a shared ancestor and that the two target persons (and the matching parents) are related.



# IBD Calling Pipeline

* input:
  * genotype array calls with valid RSID's
  * LD map in PLINK format
* output:
  * IBD segments matched to ancestral populations

