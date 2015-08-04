#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"
echo ""

(
    set -x
    # ${SELF_IP} set by settings
    export DRQUEUE_MASTER=${SELF_IP}
)

while :
do
    echo "---------------------------------------------------"
    (
        set -x
        drqueue computer list -v --no-ssh
    )
    echo "---------------------------------------------------"
    read -p "Press [ENTER] to list again, [CTRL+C] to stop..."
done

