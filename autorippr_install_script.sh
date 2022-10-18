#!/bin/bash

clear
echo "Installing Autorippr (MakeMKV v1.17.2)..."
cd ~


## Ubuntu fix for installing packages
sudo apt-get purge -y runit
sudo apt-get purge -y git-all
sudo apt-get purge -y git
sudo apt-get autoremove
sudo apt update


## Install Git & Curl
sudo apt install -y git
sudo apt install -y curl



## Install Python2 and Pip2
sudo apt-get install -y python2-dev
python2 --version

curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
pip2 --version


## Intall MakeMKV required tools and libraries
sudo apt-get install build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev


## Install FFMPEG
sudo apt-get install -y yasm
cd ~
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --prefix=/tmp/ffmpeg --enable-static --disable-shared --enable-pic
make install
sudo apt install -y ffmpeg
ffmpeg -version


## Install MakeMKV
cd ~
wget http://www.makemkv.com/download/makemkv-bin-1.17.2.tar.gz
wget http://www.makemkv.com/download/makemkv-oss-1.17.2.tar.gz
tar -zxmf makemkv-oss-1.17.2.tar.gz
tar -zxmf makemkv-bin-1.17.2.tar.gz

cd makemkv-oss-1.17.2
PKG_CONFIG_PATH=/tmp/ffmpeg/lib/pkgconfig ./configure
make
sudo make install
rm -rf /tmp/ffmpeg

cd ..
cd makemkv-bin-1.17.2
make
sudo make install


## Install Handbrake CLI
sudo apt-get install handbrake-cli


## Install MKVToolNix
sudo wget -O /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg
sudo apt install -y apt-transport-https
sudo apt install -y mkvtoolnix


## Install Java prerequisite for Filebot
sudo apt install -y default-jre


## Install Filebot
if [ `uname -m` = "i686" ]
then
   wget -O filebot-i386.deb 'http://filebot.sourceforge.net/download.php?type=deb&arch=i386'
else
   wget -O filebot-amd64.deb 'http://filebot.sourceforge.net/download.php?type=deb&arch=amd64'
fi
sudo dpkg --force-depends -i filebot-*.deb && rm filebot-*.deb


## Install Python Required Packages
sudo pip2 install tendo pyyaml peewee pushover python-pushover pymediainfo


## Install additional dependencies
sudo apt-get install -y libmediainfo-dev


## Install Autorippr
cd ~
git clone https://github.com/mp-strachan/Autorippr.git autoripper
cd autorippr
git checkout
cp settings.example.cfg settings.cfg


## Update keys library
wget http://fvonline-db.bplaced.net/fv_download.php?lang=eng -O KEYDB.cfg
mv KEYDB.cfg ~/.MakeMKV


## Verification Test
clear
echo "Verifying Autoripper..."
cd ~/autorippr
python2 autorippr.py --test


## Completion Message
echo " "
echo " "
echo "############################################################################################"
echo "##                                                                                        ##"
echo "##                                    Install Complete!                                   ##"
echo "##                                                                                        ##"
echo "##                                == Configure Autorippr ==                               ##"
echo "##                                 ~/autorippr/settings.cfg                               ##"
echo "##                                                                                        ##"
echo "##                                   == Add to cron ==                                    ##"
echo "##    */5 * * * * /usr/bin/python2 /home/ripper/autorippr/autorippr.py --all --silent     ##"
echo "##                                                                                        ##"
echo "##                                                                                        ##"
echo "##                                == Setup FileBot ==                                     ##"
echo "##              Purchase a license at:   https://www.filebot.net/purchase.htm             ##"
echo "##          Please run 'filebot --license *.psm' to install your FileBot license.         ##"
echo "##                                                                                        ##"
echo "############################################################################################"
