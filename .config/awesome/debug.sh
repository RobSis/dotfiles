Xephyr -ac -br -noreset -screen 1024x768 :1.0 &
sleep 1
DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua
