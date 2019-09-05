#!/usr/bin/env python

import sys

def main(inputFile):
    sum = 0
    with open(inputFile) as ins:
        for line in ins:
            data = line.strip().split()
            start = int(data[5])
            end = int(data[6])
            sum += end - start
    print sum
if __name__ == "__main__":
    main(sys.argv[1])
