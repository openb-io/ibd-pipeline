#FROM debian:sid
FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install default-jre-headless && \
    apt-get -y install wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /openb.io/

RUN mkdir -p /Users/rob/Desktop/family

VOLUME /Users/rob/Desktop/family

COPY get-dependencies.sh /openb.io/

RUN cd /openb.io; ./get-dependencies.sh

COPY run-pipeline.sh /openb.io/

ENTRYPOINT [ "cd",  "/openb.io;", "./run-pipeline.sh", "/Users/rob/Desktop/family/subject-no-allosome.list", "/Users/rob/Desktop/family/longs.ped" ] 