#FROM debian:sid
FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install default-jre-headless && \
    apt-get -y install wget && \
    apt-get -y install tabix bcftools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /openb.io/inputs

VOLUME /openb.io/inputs

COPY get-dependencies.sh /openb.io/

RUN cd /openb.io; ./get-dependencies.sh

COPY run-pipeline.sh /openb.io/

ENTRYPOINT cd /openb.io; ./run-pipeline.sh inputs/subjects.list inputs/family.ped