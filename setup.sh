# setup.sh
# Written by Andrew Moore
# Created: 07-25-2020
# Modified: 07-25-2020

# This script will configure the NAO operating system and allow it
# to use Python 2.7.  Please note that as of this writing
# Python 2.7 is deprecated, this script is for proof of concept
# only.

# Install portaudio to avoid issues later on
sudo emerge portaudio

# Grab the newest ebuilds
sudo emerge --sync

# Create the new directories for the repository
sudo mkdir /var/db/repos
sudo mkdir /var/db/repos/gentoo

# Create a new partition on the device added to VM
(
echo n
echo p
echo 1
echo
echo
echo w
) | sudo fdisk /dev/sdc

# Create a filesystem on the new partition
sudo mke2fs -t ext3 /dev/sdc1

# Mount the new filesystem
sudo mount /dev/sdc1 /var/db/repos/gentoo

# Update the portage tool to the latest version
tar --extract --gz --verbose --file portage-portage-2.3.103.tar.gz
sudo python portage-portage-2.3.103/setup.py install

# Update the portage tree to enable package installation
sudo emerge-webrsync

# Set the profile to a valid selection
sudo eselect profile --set 1

# Correct the destinaiton of make.profile
sudo rm /etc/make.profile
sudo ln -s /usr/portage/profiles/default/linux/x86/17.0 /etc/make.profile

# Restart sshd service
sudo rc-service sshd restart

# Add a rule to iptables to allow ssh connections (enables scp)
sudo iptables -A INPUT -p tcp --dport ssh -j ACCEPT

# Enable OSS in PulseAudio
sudo sed -i '$ a load_module module_oss' /etc/pulse/default.pa

# Unzip the Packages directory and do some housekeeping
unzip Packages.zip
rm -rf __MACOSX
sudo rm -rf portage-portage-2.3.103

# Set up the audio requirements for Google Assistant

cd Packages

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
cd oautlib-3.1.0
sudo python setup.py install
cd ..

# request-oauthlib
tar --extract --gz --verbose --file requests-oauthlib-1.3.0.tar.gz
cd requests-oautlib-1.3.0
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
cd ../..

# Clean up installation files
sudo rm -rf Packages
rm Packages.zip

