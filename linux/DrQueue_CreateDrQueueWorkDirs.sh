#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate
SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"
(
    set -x
    python src/drqueueipython/setup.py create_drqueue_dirs --basepath="${DRQUEUE_ROOT}"
)
echo ""
read -p "Press [ENTER]..."