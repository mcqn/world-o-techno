#!/bin/bash -x

# wait for sonic-pi to start
# (a RPi 2 is very slow)
sleep 65

# set the default audio output to be the headphone jack
amixer cset numid=3 1

# set audio volume to full
amixer sset PCM 100%

# and Master volume to ~50%
amixer set "Master" 46444,46444

# play our tune
cat /home/pi/world-o-techno/world-o-techno.rb|sonic_pi
