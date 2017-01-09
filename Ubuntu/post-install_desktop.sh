#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### add GNOME 3 repository and install GNOME 3'
sudo apt-add-repository -y ppa:gnome3-team/gnome3-staging
sudo apt-add-repository -y ppa:gnome3-team/gnome3
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-gnome-desktop \
    gnome-tweak-tool \
    dconf-editor

echo '### add Paper repository and install Paper GTK theme'
sudo add-apt-repository -y ppa:snwh/pulp
sudo apt-get update -q && sudo apt-get install -y \
    paper-gtk-theme \
    paper-icon-theme \
    paper-cursor-theme
