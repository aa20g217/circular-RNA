FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:9a7d-main

#install and setup conda
RUN apt-get update && apt-get install -y git wget
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
   && rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda config --add channels bioconda --add channels conda-forge --add channels ambermd
RUN python3 -m pip install --upgrade requests

RUN conda install -c bioconda star
RUN conda install -c bioconda ucsc-genepredtogtf

RUN pip install circexplorer2

# You can use local data to construct your workflow image.
COPY pipeline.sh /root/pipeline.sh

# STOP HERE:
# The following lines are needed to ensure your build environement works
# correctly with latch.
COPY wf /root/wf
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
