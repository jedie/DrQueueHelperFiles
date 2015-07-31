#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"

# rename existing log files:
cd ${DRQUEUE_ROOT}/logs/
find . -name '*.log' -print0 | while IFS= read -r -d $'\0' log; do
    log=$(basename "${log}")
    new_filename=$(date -r "${log}" +%Y%m%d-%H%M)-${log}
    (
        set -x
        mv "${log}" "${new_filename}"
    )
done
echo ""
(
    set -x
    drqueue -v --no-ssh master
)
echo ""
read -p "Press [ENTER]..."