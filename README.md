# circular-RNA Annotation Pipeline

#### **Summary**
This repository contains a latch workflow/pipeline for the circular RNA annotation from bulk RNA-Seq data using the CIRCexplorer2 tool.

#### **Input**

* Raw Data
    - A folder containing all fastq.gz files. Every sample should have read1 and read2 fastq.gz files in this folder. There should be an _R1 and _R2 (suffix) at the end of the Read1 and Read2 files of a sample. Example: sample1_R1 and sample1_R2.

* Species
    - Specify the species. Current wf will work for human and mouse samples only.

#### **Output**
Alilignment and circular RNA annotation results. Please click [here](https://circexplorer2.readthedocs.io/en/latest/modules/annotate/) to know the details about the format of circularRNA_known.txt files.

#### **Latch workflow link**
https://console.latch.bio/explore/83134/info
