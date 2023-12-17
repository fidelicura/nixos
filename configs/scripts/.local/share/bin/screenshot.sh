#!/usr/bin/env



now=$(date +"%Y-%m-%d-%H-%M-%S")
sel=$(slop -f "-i %i -g %g")
pictures=$HOME/documents/pictures

shotgun -f png $pictures/$now.png $sel
xclip -in -selection clipboard -target image/png $pictures/$now.png
