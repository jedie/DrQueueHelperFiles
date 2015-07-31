#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate
set -x
drqueue --help >drqueue_help.txt
gnome-open drqueue_help.txt