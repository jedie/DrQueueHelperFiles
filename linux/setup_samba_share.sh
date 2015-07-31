#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"

echo ""
(
    set -x
    # delete old entry
    sudo net usershare delete DrQueue 2>/dev/null

    # create share with full access to everyone:
    sudo net usershare add DrQueue ${DRQUEUE_ROOT} "DrQueue root dir" Everyone:f guest_ok=y

    { echo "---------------------------------------------------"; } 2>/dev/null

    sudo net usershare info

    { echo "---------------------------------------------------"; } 2>/dev/null

    sudo service smbd restart
)
echo ""
read -p "Press [ENTER]..."