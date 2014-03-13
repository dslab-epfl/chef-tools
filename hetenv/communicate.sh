#!/bin/bash
#
# Copyright 2014 EPFL. All rights reserved.

DIR="$(cd "$( dirname "$0" )" && pwd )"
CHEF_ROOT=$DIR/../..

rm -f send_channel
rm -f recv_channel

mkfifo send_channel
mkfifo recv_channel

$CHEF_ROOT/lua/chef/lua_runner.py $DIR/sender.lua send_channel recv_channel
