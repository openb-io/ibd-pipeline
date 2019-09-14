#!/bin/bash
sudo docker run -t --rm -v /Users/rob/git/openb.io/ibd-pipeline/inputs:/openb.io/inputs -m 8g --cpus 4 openbio-ibd-pipline:0.1
