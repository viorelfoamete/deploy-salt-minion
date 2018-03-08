# This is a state which will install salt-minion on your hosts using Salt SSH
# It will install the SaltStack repo, install salt-minion from that repo, enable and start the salt-minion service and
# declare master in /etc/salt/minion file
salt-minion:
    # Install SaltStack repo for RHEL/Centos systems
    pkgrepo.managed:
        - name: salt-latest
        - humanname: SaltStack Latest Release Channel for RHEL/Centos $releasever
        - baseurl: https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
        - gpgkey: https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
        - gpgcheck: 1
        - enabled: 1
    # Install the salt-minion package and all its dependencies.
    pkg:
        - installed
        # Require that SaltStack repo is set up before installing salt-minion.
        - require:
            - pkgrepo: salt-latest
    # Start and enable the salt-minion daemon.
    service:
        - running
        - enable: True
        # Require that the salt-minion package is installed before starting daemon
        - require:
            - pkg: salt-minion
        # Restart salt-minion daemon if /etc/salt/minion file is changed
        - watch:
            - file: /etc/salt/minion

# Configure Salt master in conf file
/etc/salt/minion:
    file.managed:
        # File will contain only one line
        - contents:
            - master: <IPADDRESS OR HOSTNAME>