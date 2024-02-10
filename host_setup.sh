#!/bin/bash
set -x

#
# host_setup.sh
#
# Initial host setup for OneFinity validator nodes
#
# frankf1957@GitHub
# Sat Feb 10 02:48:30 PM UTC 2024
#


function update_system_os {
    sudo apt update
    sudo apt dist-upgrade
    sudo apt autoclean
    sudo apt autoremove --purge
}


function set_timezone_utc {
    sudo timedatectl set-timezone UTC
}


function create_user_accounts {
    getent passwd onefinity && true || sudo useradd -c "OneFinity Validator" -s /bin/bash -m onefinity
    sudo usermod -aG sudo onefinity
}


function create_sudo_rules {
    # elrond-go-scripts-v2 want user elrond to use sudo with NOPASSWD
    # allow for testnet only, not for prodnet
    # %elrond ALL=(ALL) NOPASSWD:ALL
    sudo echo '%elrond ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/elrond-ALL-NOPASSWD
}


function create_ssh_public_keys {
    # add SSH public keys for user myuser
    sudo mkdir -p ~myuser/.ssh
    sudo cat <<'EOF' > ~myuser/.ssh/authorized_keys
ssh-ed25519 AAAA............................................................J87y myuser@Darwin.local
ssh-ed25519 AAAA............................................................Uqc5 elrond@MobaXterm
EOF
    sudo chown -R myuser:myuser ~myuser/.ssh

    # add SSH public keys for user elrond
    sudo mkdir -p ~elrond/.ssh
    sudo cat <<'EOF' > ~elrond/.ssh/authorized_keys
ssh-ed25519 AAAA............................................................J87y myuser@Darwin.local
ssh-ed25519 AAAA............................................................Uqc5 elrond@MobaXterm
EOF
    sudo chown -R elrond:elrond ~elrond/.ssh
}


function install_configure_ufw {
    # Install and Configure a Firewall
    sudo apt -y install ufw

    # backup /etc/default/ufw before changes
    cp -p /etc/default/ufw{,-$(date "+%s").backup}

    # Disable IPv6 in UFW
    sudo perl -spi -e 's/IPV6=yes/IPV6=no/g' /etc/default/ufw;

    # Configure firewall rules, turn logging on, enable firewall:
    sudo ufw allow 22/tcp
    sudo ufw allow 37373:38383/tcp
    sudo ufw logging on
    sudo ufw enable
}


function configure_strict_ssh {
    # backup /etc/ssh/sshd_config before changes 
    cp -p /etc/ssh/sshd_config{,-$(date "+%s").backup}

    # comment the following defaults
    sudo perl -spi -e 's/^(Protocol|PermitRootLogin|PasswordAuthentication|PermitEmptyPasswords)/#\1/g;' /etc/ssh/sshd_config
    sudo cat <<'EOF' >> /etc/ssh/sshd_config

# Use only SSH Protocol 2
Protocol 2

# Prevent root user from login
PermitRootLogin no

# Disable passsword authentication
PasswordAuthentication no
PermitEmptyPasswords no
EOF
}



