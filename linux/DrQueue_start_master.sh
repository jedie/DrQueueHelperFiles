#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"
(
    set -x
    drqueue -v --no-ssh master
)
echo ""
read -p "Press [ENTER]..."