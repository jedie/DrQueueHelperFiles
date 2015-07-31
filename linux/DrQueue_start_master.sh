#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"

LOG_DIR=${DRQUEUE_ROOT}/logs
LOGS=("ipcontroller.log" "mongodb.log")

# rename existing log files:
cd ${LOG_DIR}
for log in ${LOGS[@]}; do
    if [ -f "${log}" ]; then
        log=$(basename "${log}")
        new_filename=$(date -r "${log}" +%Y%m%d-%H%M)-${log}
        (
            set -x
            mv "${log}" "${new_filename}"
        )
    fi
done
echo ""


cd ${DRQUEUE_ROOT}/ipython/profile_default/pid
for pidfile in *.pid; do
    echo "quit ${pidfile}"
    pid=$(cat ${pidfile})
    (
        set -x
        kill -QUIT ${pid}
    )
done

echo ""



(
    set -x
    { echo "---------------------------------------------------"; } 2>/dev/null

    # ${SELF_IP} set by settings
    export DRQUEUE_MASTER=${SELF_IP}

    drqueue -v --no-ssh master

    { echo "---------------------------------------------------"; } 2>/dev/null

    sleep 1

    # Default is 700
    chmod 755 ${DRQUEUE_ROOT}/ipython/profile_default/security

    # Default is 600
    chmod 744 ${DRQUEUE_ROOT}/ipython/profile_default/security/*.json
)
echo ""
cd ${LOG_DIR}
(
    set -x
    tail -f ${LOGS[@]}
)
echo ""
read -p "Press [ENTER]..."