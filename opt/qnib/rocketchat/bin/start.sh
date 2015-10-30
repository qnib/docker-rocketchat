#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv mongodb

cd /opt/rocketchat/bundle/
node main.js
