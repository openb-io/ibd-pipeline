#!/bin/bash

apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install default-jre-headless && \
    apt-get -y install wget && \
    apt-get -y install tabix bcftools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

./get-dependencies.sh
