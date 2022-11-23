"""
circular RNA analysis workflow. This workflow allows users to annotate circular RNAs from bulk RNA-Seq data using the CIRCexplorer2 toolset.
"""
#"SRR1635435_1.fastq.gz SRR1635436_1.fastq.gz"
from pathlib import Path
import subprocess
from flytekit import LaunchPlan, workflow
from latch.types import LatchDir,LatchFile
from latch import large_task
from latch.resources.launch_plan import LaunchPlan
import os,shutil
import glob

@large_task
def runPipeline(fastq: LatchDir,output_dir: LatchDir,org:str="human") -> LatchDir:

    #copy input data
    if os.path.exists("/root/tempDir/"):
        os.remove("/root/tempDir/")
    shutil.copytree(fastq.local_path, "/root/tempDir/")

    #ref genome
    if org=="human":
        index=LatchDir("latch:///welcome/circrna/human/index")
        ann=LatchFile("latch:///welcome/circrna/human/hg38_anno_all.txt")
        ref=LatchFile("latch:///welcome/circrna/human/hg38.fa")

    elif org=="mouse":
        index=LatchDir("latch:///welcome/circrna/mouse/index")
        ann=LatchFile("latch:///welcome/circrna/mouse/mm10_anno_all.txt")
        ref=LatchFile("latch:///welcome/circrna/mouse/mm10.fa")
    else:
        print("Only mouse and human samples are allowed.")
        return None



    subprocess.run(["bash","pipeline.sh",index,ann,ref])


    local_output_dir = str(Path("/root/results/").resolve())
    remote_path=output_dir.remote_path
    if remote_path[-1] != "/":
       remote_path += "/"

    return LatchDir(local_output_dir,remote_path)


@workflow
def circularRNAwf(fastq: LatchDir,output_dir: LatchDir,org:str="human") -> LatchDir:
    """

    circular RNA
    ----

    circular RNA analysis workflow. This workflow allows users to annotate circular RNAs from bulk RNA-Seq data using the CIRCexplorer2 toolset.

    __metadata__:
        display_name: circular RNA.
        author:
            name: Akshay
            email: akshaysuhag2511@gmail.com
            github:
        repository:
        license:
            id: MIT

    Args:
        fastq:
          A folder containing all fastq.gz files. Every sample should have read1 and read2 fastq.gz files in this folder. There should be an _R1 and _R2 (suffix) at the end of the Read1 and Read2 files of a sample. Example: sample1_R1 and sample1_R2.
          __metadata__:
            display_name: Input

        org:
         Specify the species. Current wf will work for human and mouse samples only.
         __metadata__:
            display_name: Species

        output_dir:
          Where to save the report and results?.
          __metadata__:
            display_name: Output Directory
    """
    return runPipeline(fastq=fastq,org=org,output_dir=output_dir)
