#!/usr/bin/env bash

# https://unix.stackexchange.com/a/1498
shopt -s expand_aliases
source "$HOME"/.bash_aliases

# This is the built-in screen.
LAPTOP='LEN40BA'

# https://linuxhint.com/run-powershell-script-cmd/
# https://devblogs.microsoft.com/scripting/use-powershell-to-discover-multi-monitor-information/
# NOTE: quote windows backslashes! (root\wmi)
MONITOR_INFO="$(powershell.exe -Command Get-CimInstance -Namespace 'root\wmi' -ClassName WmiMonitorBasicDisplayParams | dos2unix)"

# sample content (upstairs):
#
#Active                        : True
#DisplayTransferCharacteristic : 120
#InstanceName                  : DISPLAY\LEN40BA\4&3b1e8858&0&UID8388688_0
#MaxHorizontalImageSize        : 34
#MaxVerticalImageSize          : 19
#SupportedDisplayFeatures      : WmiMonitorSupportedDisplayFeatures
#VideoInputType                : 1
#PSComputerName                :
#
#Active                        : True
#DisplayTransferCharacteristic : 120
#InstanceName                  : DISPLAY\SAM1017\4&3b1e8858&0&UID4145_0
#MaxHorizontalImageSize        : 63
#MaxVerticalImageSize          : 36
#SupportedDisplayFeatures      : WmiMonitorSupportedDisplayFeatures
#VideoInputType                : 1
#PSComputerName                :

# The 'LEN40BA' screen is the laptop's built-in monitor, remove it from the
# results; regardless of the discovery order we always get the other screen(s).
DEVICE="$(awk -F '\' '/^InstanceName/ { print $2 }' <<<"$MONITOR_INFO" | grep -v "$LAPTOP" | tail -1)"

# if no external monitor is connected, $DEVICE is empty (filtered-out); set it back
test -n "$DEVICE" || DEVICE="$LAPTOP"

# office, laptop, upstairs, downstairs : aliases setting terminal font size in ~/.bash_aliases (see bin/set_terminal_font_size.sh)

echo -e -n "\nDetected screen '$DEVICE'; "
# These tests could be improved by looking at MaxHorizontalImageSize etc.
[ "$DEVICE" = "$LAPTOP" ] && {
        echo "setting font size to 'laptop'."
        laptop
        exit 0
}

[ "$DEVICE" = "SAM1017" ] && {
        echo "setting font size to 'upstairs'."
        upstairs
        exit 0
}

[[ "$DEVICE" =~ HPN337C|HPN337E ]] && {
        echo "setting font size to 'downstairs'."
        downstairs
        exit 0
}

[ "$DEVICE" = "SAM7174" ] && {
        echo "setting font size to 'office'."
        office
        exit 0
}

# default: office
office
