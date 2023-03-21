#!/usr/bin/env bash

# https://stackoverflow.com/questions/66007562/change-font-type-and-size-programmatically-on-the-console

# https://www.reddit.com/r/bashonubuntuonwindows/comments/8dhhrr/comment/dxn9obq/
WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | dos2unix)"
SETTINGS="$(ls /mnt/c/Users/"$WIN_USER"/AppData/Local/Packages/Microsoft.WindowsTerminal*/LocalState/settings.json)"
# https://stackoverflow.com/a/32931403
mapfile -t PROFILES < <(jq -r '.profiles.list[].name' "$SETTINGS")

test -z "$1" && {
        echo "Font size is obligatory (and the only) parameter." 1>&2
        exit 1
}

re='^[1-9][0-9]*$'
if ! [[ $1 =~ $re ]] ; then
        echo "error: '$1' needs to be a positive integer > 3" 1>&2
        exit 1
fi

test "$1" -gt 3 || {
        echo "Don't be silly; font size less than 4 is ridiculous." 1>&2
        exit 1
}

type jq >/dev/null 2>&1 || {
        echo "Install 'jq' first." 1>&2
        exit 1
}

type sponge >/dev/null 2>&1 || {
        echo "Install 'moreutils' first." 1>&2
        exit 1
}

PSTRING=''

for p in "${PROFILES[@]}"; do
        test -n "$PSTRING" && PSTRING="${PSTRING},"
        PSTRING="${PSTRING}.name==\"$p\""
done

# https://stackoverflow.com/a/65822084
jq '.profiles.list[] |= (select('"$PSTRING"').font.size='"$1"')' "$SETTINGS" | sponge "$SETTINGS"
