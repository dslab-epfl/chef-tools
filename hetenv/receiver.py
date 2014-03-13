#!/usr/bin/env python
#
# Copyright 2014 EPFL. All rights reserved.

"""Receiver end in a heterogenous environment."""

import sys

def main():
    send_file_name, recv_file_name = sys.argv[1:3]

    sendf = open(send_file_name, "r")
    print "RECEIVER: Open send pipe"
    recvf = open(recv_file_name, "w")
    print "RECEIVER: Open recv pipe"

    message = sendf.read()
    print "RECEIVER: Read message"
    
    print >>recvf, "Hello"
    print "RECEIVER: Sent response"

    sendf.close()
    recvf.close()


if __name__ == "__main__":
    main()
