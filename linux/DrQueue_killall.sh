#!/bin/bash
# Put these file in ~/DrQueue_env/
PROCESS=$(pwd)/bin/python2
ps aux | grep "${PROCESS}"
(
    set -x
    killall -v "${PROCESS}"
)
echo ""
read -p "Press [ENTER]..."