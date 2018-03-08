# install-salt-minion
Deploy salt-minion with salt-ssh

Set Up Salt Roster FilePermalink
The Roster file contains target system information, connection details and credentials. The Default location for the Roster file is: /etc/salt/roster.

Note
The Roster file is configured on the master server.
Open /etc/salt/roster with an editor. Define the client systems, by adding the following lines to the file:

This is an example of minimal host definition

/etc/salt/roster
1
2
3
4
minion-to-be-added:
     host: <IPADDRESS OR HOSTNAME>
     user: <username>
     passwd: <password>
Note
The Roster file stores data in YAML format. Do not add unnecessary spaces to the config file.
If you have a public key stored on the minion, and a private key on the master system, you can configure access to a minion using a private key. For public key authentication, add the following lines to the Roster file:

/etc/salt/roster
1
2
3
4
5
#This is an example of minimal host definition using private key:
minion-to-be-added:
    host: <IPADDRESS OR HOSTNAME>
    user: <username>
    priv: /<username_home_folder>/.ssh/id_rsa
Note
Using SSH keys is the safest way to access your minions because passwords are not being stored in plain text.
To set up connection to a minion as a regular user, you have to configure a few files. In this case Salt will leverage privileges via sudo. In order to use sudo, set sudo: True in the host definition section of the Roster file. By default sudo will only work when the real user is logged in over TTY. You can overcome this in two ways:

a. Disable the TTY check by commenting a line in the sudoers file on your minion:

/etc/sudoers
1
# Defaults requiretty
b. Force TTY allocation by setting the tty: True option in your Roster file:

/etc/salt/roster
1
2
3
4
5
6
minion-to-be-added:
    host: <IPADDRESS OR HOSTNAME>
    user: <username>
    passwd: <password>
    sudo: True
    tty: True
Note
Permissions leverage via sudo works only if the NOPASSWD option is set up for the user that is connecting to the minion in /etc/sudoers. More information on Roster files can be found in the Roster files documentation.
Check that the master server has access to the client using the salt-ssh command:

[root@master ~]# salt-ssh minion-to-be-added test.ping
The output should be:

minion-to-be-added:
    True
Note
If SSH keys weren’t deployed, you may receive the The host key needs to be accepted, to auto accept run salt-ssh with the -i flag: message. In this case just run salt-ssh with -i flag. This key will let Salt automatically accept a minion’s public key. This has to be done only once, during the initial SSH keys exchange.
