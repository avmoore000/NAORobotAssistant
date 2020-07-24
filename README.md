#NAORobotAssistant
Integrating Google Assistant into NAO Robot

These are working notes and will be revised as I go.

Setting up NAO VM:

1.  Install VirtualBox, or your prefered virtual machine environment, I will
    be assuming VirtualBox.  Some of these steps may differ if you are using 
    a different environment.

2.  Download opennao-vm-2.2.2.17.ova

3.  Deploy the ova as an appliance.

4.  Start the VM in whichever mode you like, we will be using a terminal
    to ssh to the VM for convinence, so minimize the VM after starting it.

5.  Open your terminal, and ssh to the now running VM.  OpenNAO uses the localhost
    on port 2222 as default.

    ssh nao@localhost -p 2222

The next step is to upgrade Gentoo since this version of OpenNAO is running a kernel
from 2012.

Gentoo Upgrade Steps:

The version of Gentoo being used by the VM is very old, so it needs to be updated.
The following sequence of steps can be used to bring the kernel to the latest version
of Gentoo, while maintining the integrity of the NAO OS.

1.  Download a tarball of the latest portage for later, this can be 
    found at https://github.com/gentoo/portage/releases

2.  Perform a sync with emerge to grab the latest gentoo ebuild

    sudo emerge --sync

3.  Update portage to the latest version using the tarball from step 1.

    a.  Extract the archive

        tar --extract --gz --verbose --file portageName.tar.gz

    b.  Install the latest version

        cd portageName
        sudo python setup.py install

4.  At this point eselect will be broken, fix this as follows:

    a.  Create the directory /var/db/repos/gentoo

        mkdir /var/db/repos
        mkdir /var/db/repos/gentoo

    b.  Create a symbolic link to /usr/portage/profiles in /var/db/repos/gentoo

        cd /var/db/repos/gentoo
        sudo ln -s /usr/portage/profiles/ profiles

5.  Change to a valid profile

    a.  eselect profile --list

        This will give a list of available profiles.

    b.  eselect profile --set [option number]

        This will set the profile to the selected [option number]

    c.  Running eselect profile --list should show that the profile you selected
        is active.

Step 5 will bring the system straight to Gentoo 17, the latest release.  Next we
need to upgrade python2.7 to python3, which is required by the current
iteration of Google Assistant.

6.  Upgrading Python

    a.  First grab a tarball of the latest python release from python.org.  In this case
        I am using Python 3.8

    b.  Next scp the archive to the home directory on the NAO Robot

        scp -P 2222 Python-3.8.4.tgz nao@localhost:/home/nao

    c.  Extract the archive

        tar --extract --gz --verbose --file Python-3.8.4.tgz

    d.  Change directories to the newly extracted python directory.

    e.  Install the new version of python as follows:

        ./configure --enable-optimizations
        make
        make test    - This part can be skipped, but it is recommended to catch any 
                       missing dependencies before the installation.
        sudo make install 

7.  After a succesful installation, python3 should be accessible via
   
        python3

Installing Google Assistant SDK

1.  Download and install all of the required libraries in this order

    A.  Audio Requirments

        pycparser-2.20
        cffi-1.14.0
        portaudio
        sounddevice-0.4.0

    B.  Google Specific requirements

        oauthlib-3.1.0
        request-oauthlib-1.3.0
        google-auth-1.19.2
        google-auth-oauthlib-0.4.1
        oauthlib-3.1.0
        click-7.1.2
        google-assistant-sdk-0.6.0

        touch googlesamples/assistant/grpc/requirements.txt
