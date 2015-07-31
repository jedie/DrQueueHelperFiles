#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"

echo ""
(
    set -x

    net usershare info -l

    { echo "---------------------------------------------------"; } 2>/dev/null

    # If the same share was created via sudo or from a other user:
    #sudo net usershare delete DrQueue

    # create share with full access to current user:
    net usershare add DrQueue ${DRQUEUE_ROOT} "DrQueue root dir" ${USER}:F

    { echo "---------------------------------------------------"; } 2>/dev/null

    net usershare info -l

)
echo ""
read -p "Press [ENTER]..."