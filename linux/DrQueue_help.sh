#!/bin/bash

# Put these file in ~/DrQueue_env/
source bin/activate

echo ""
(
    set -x

    drqueue --help >drqueue_help.txt

    { echo "---------------------------------------------------"; } 2>/dev/null

    gnome-open drqueue_help.txt
)
echo ""
read -p "Press [ENTER]..."