FROM python:3.11.7
###########################################################################################
RUN apt-get update
RUN pip install --no-cache-dir pod5==0.3.10
RUN pip install --no-cache-dir numpy==1.26
###########################################################################################
LABEL org.opencontainers.image.title="Sequeduct Methyl"
LABEL org.opencontainers.image.description="Sequencing analysis pipeline for validating DNA modifications (methylations) in assembly constructs"
LABEL org.opencontainers.image.url="https://github.com/edinburgh-genome-foundry/sequeduct_methyl"
LABEL org.opencontainers.image.documentation="https://github.com/edinburgh-genome-foundry/sequeduct_methyl"
LABEL org.opencontainers.image.source="https://github.com/edinburgh-genome-foundry/sequeduct_methyl/"
LABEL org.opencontainers.image.vendor="edinburgh-genome-foundry"
LABEL org.opencontainers.image.authors="Jennifer Claire Muscat"
LABEL org.opencontainers.image.revision="v0.1.0"