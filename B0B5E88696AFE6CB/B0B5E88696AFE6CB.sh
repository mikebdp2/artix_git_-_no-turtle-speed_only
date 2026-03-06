#!/bin/sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys "B0B5E88696AFE6CB"
rm -f               ./B0B5E88696AFE6CB.gpg
rm -f               ./B0B5E88696AFE6CB.asc
gpg         --export "B0B5E88696AFE6CB"       > ./B0B5E88696AFE6CB.gpg
gpg --armor --export "B0B5E88696AFE6CB"       > ./B0B5E88696AFE6CB.asc
exit 0
#
