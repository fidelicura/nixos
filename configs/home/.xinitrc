#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xwallpaper --zoom $HOME/.local/share/bg/bg.jpg &
picom &
dunst &
bspwm
