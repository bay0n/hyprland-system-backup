#!/bin/bash

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    printf '{"text":"󰂯","class":"on","tooltip":false}\n'
else
    printf '{"text":"󰂲","class":"off","tooltip":false}\n'
fi
