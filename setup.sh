# setup.sh
# Written by Andrew Moore
# Created: 07-25-2020
# Modified: 08-09-2020

# This script will configure the NAO operating system and allow it
# to use Python 2.7.  Please note that as of this writing
# Python 2.7 is deprecated, this script is for proof of concept
# only

# Install portaudio to avoid issues later on
sudo emerge portaudio

# Install OSS modules
sudo emerge alsa-oss

# Enable pulseaudio to use OSS module
sudo sed -i '$ a load_module module_oss' /etc/pulse/default.pa  

# Unzip the packages to be installed and do some housekeeping
unzip Packages.zip
rm -rf __MACOSX 
cd /home/nao/Packages

# Set up the audio requirements for Google Assistant

# New alsa-lib
tar --extract --file alsa-lib-1.2.3.2.tar.bz2
cd alsa-lib-1.2.3.2
./configure
make
sudo make install
cd /home/nao/Packages

# Install alsa-utils
tar --extract --file alsa-utils-1.2.3.tar.bz2
cd alsa-utils-1.2.3
./configure
make
sudo make install
cd /home/nao/Packages

# pycparser
tar --extract --gz --verbose --file pycparser-2.20.tar.gz
cd pycparser-2.20
sudo python setup.py install
cd ..

# cffi
tar --extract --gz --verbose --file cffi-1.14.0.tar.gz
cd cffi-1.14.0
sudo python setup.py install
cd ..

# sounddevice
tar --extract --gz --verbose --file sounddevice-0.4.0.tar.gz
cd sounddevice-0.4.0
sudo python setup.py install
cd ..

# oauthlib
tar --extract --gz --verbose --file oauthlib-3.1.0.tar.gz
cd oauthlib-3.1.0
sudo python setup.py install
cd ..

# request-oauthlib
tar --extract --gz --verbose --file requests-oauthlib-1.3.0.tar.gz
cd requests-oauthlib-1.3.0
sudo python setup.py install
cd ..

# google-auth
tar --extract --gz --verbose --file google-auth-1.19.2.tar.gz
cd google-auth-1.19.2

# Delete line 47 because it causes unknown distribution error
sed -i '47d' setup.py

sudo python setup.py install
cd ..

# google-auth-oauthlib
tar --extract --gz --verbose --file google-auth-oauthlib-0.4.1.tar.gz
cd google-auth-oauthlib-0.4.1
sudo python setup.py install
cd ..

# click
tar --extract --gz --verbose --file click-7.1.2.tar.gz
cd click-7.1.2
sudo python setup.py install
cd ..

# google-assistant
tar --extract --gz --verbose --file google-assistant-sdk-0.6.0.tar.gz
cd google-assistant-sdk-0.6.0
touch googlesamples/assistant/grpc/requirements.txt
sudo python setup.py install
cd /home/nao

# fix pulse audio
pacmd set-default-sink "auto_null"
pacmd set-default-source "auto_null.monitor"

# Clean up installation files
sudo rm -rf Packages
rm Packages.zip
rm setup.sh
