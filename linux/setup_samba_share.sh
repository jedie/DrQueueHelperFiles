#!/bin/bash
# Put these file in ~/DrQueue_env/
source bin/activate

SETTINGS_FILE=~/DrQueue_env/set_settings
echo "Read settings from: ${SETTINGS_FILE}"
source "${SETTINGS_FILE}"

echo ""
if [! "$EUID" -ne 0 ]; then
    echo "ERROR: Don't run this script with root/sudo!"
    read -p "Press [ENTER]..."
    exit -1
fi

if [ '$(groups | grep "sambashare")' == '' ]; then
    (
        set -x
        sudo usermod -aG sambashare ${USER}
        sudo smbpasswd -a ${USER}
    )
fi
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
echo "Note:"
echo "Samba restart is *not* needed."
echo ""
echo "Mount the share under windows with, e.g:"
echo "C:\> net use Q: \\\\${SELF_IP}\DrQueue /PERSISTENT:YES"
echo ""
read -p "Press [ENTER]..."