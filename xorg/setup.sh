xrandr --output eDP --set "TearFree" on
xrandr --output eDP --set "scaling mode" "Full aspect"

xinput set-prop "ELAN2602:00 04F3:3109 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "ELAN2602:00 04F3:3109 Touchpad" "libinput Natural Scrolling Enabled" 1

xinput set-prop "Logitech USB Optical Mouse" "libinput Natural Scrolling Enabled" 1
xinput set-prop "Logitech USB Optical Mouse" "libinput Accel Speed" -0.6

setxkbmap -option caps:escape
setxkbmap -model pc104 -layout us,ru -option grp:rctrl_rshift_toggle

xset r rate 200 50
