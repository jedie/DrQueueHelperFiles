#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"
echo ""
while :
do
    echo "---------------------------------------------------"
    (
        set -x
        which python
        python submit_job.py
    )
    echo "---------------------------------------------------"
    read -p "Press [ENTER] to list again, [CTRL+C] to stop..."
done

