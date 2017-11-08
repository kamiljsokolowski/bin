#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### get the latest graphics drivers ###'
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update -q && sudo apt-get install -y \
    nvidia-378

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

echo '### add ARC repository and install ARC GTK theme'
# arc theme
echo "deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /" |sudo tee -a /etc/apt/sources.list.d/arc-theme.list \
wget -nv https://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key -O /tmp/Release.key \
    && sudo apt-key add /tmp/Release.key
sudo apt-get update -q && sudo apt-get install -y \
    arc-theme
# icons
git clone https://github.com/horst3180/arc-icon-theme --depth 1 ${GIT_BARE_REPO}/arc-icon-theme
cd ${GIT_BARE_REPO}/arc-icon-theme \
    && ./autogen.sh --prefix=/usr \
    && sudo make install
cd -

echo '### add desktop app repositories and install desktop apps'
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3          # Sublime Text
sudo add-apt-repository -y ppa:webupd8team/atom            # Atom
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer            # GRUB Customizer
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" |sudo tee -a /etc/apt/sources.list.d/dropbox.list \
    && sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E            # Dropbox
sudo add-apt-repository -y ppa:webupd8team/java            # Oracle Java
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/google.list         # Google Chrome repo
wget http://repo.vivaldi.com/stable/linux_signing_key.pub -P /tmp \
    && sudo apt-key add /tmp/linux_signing_key.pub \
    && echo "deb [arch=amd64] http://repo.vivaldi.com/stable/deb/ stable main" |sudo tee --append /etc/apt/sources.list.d/vivaldi.list            # Vivaldi repo
sudo apt-add-repository -y ppa:pipelight/stable         # Silverlight OSS counterpart
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections            # auto-accept Oracle Java license
sudo apt-get update -q && sudo apt-get install -y \
    grub-customizer \
    dropbox \
    vinagre \
    sublime-text-installer \
    atom \
    google-chrome-stable \
    vivaldi-stable \
    pidgin \
    pidgin-sipe \
    deluge \
    rdesktop \
    oracle-java8-installer \
    browser-plugin-freshplayer-pepperflash \
    pipelight-multi \
    && sudo pipelight-plugin --enable silverlight \
    && sudo pipelight-plugin --enable widevine

echo '### add multimedia repositories and install multimedia codecs and players'
echo "deb http://repository.spotify.com stable non-free" | sudo tee --append /etc/apt/sources.list.d/spotify.list \
    && sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886            # Spotify client repo
sudo apt-get update -q && sudo apt-get install -y \
    ubuntu-restricted-extras \
    ubuntu-restricted-addons \
    libdvdcss2 \
    libdvdnav4 \
    libdvdread4 \
    spotify-client \
    vlc
