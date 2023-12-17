#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

dunst &
pipewire &
pipewire-pulse &
xwallpaper --zoom $HOME/.config/bg/bg.jpg &
picom &
dbus-run-session bspwm
