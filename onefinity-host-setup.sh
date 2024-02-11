#!/bin/bash

#
# onefinity-host-setup.sh
#
# Initial host setup for OneFinity validator nodes
#
# frankf1957@GitHub
# Sat Feb 10 02:48:30 PM UTC 2024
#

# exit immediately on error
set -e

# the name of the onefinity user account
ONEFINITY_USERNAME="onefinity"


function print_welcome_message {
    cat <<'EOF'

Welcome to the initial host setup for OneFinity validator nodes.
--------------------------------------------------------------------------------

This script is intended to be run on a fresh Ubuntu VPS, prior to installing and
running OneFinity validator nodes. 

This script will update your system with the latest patches available from Ubuntu,
create a onefinity user account, create SSH keys for the onefinity user account,
install and configure a firewall to protect the host and configure SSH to increase
security and prevent unauthorized access. 

Press <enter> to continue, or <control+c> to cancel. 

EOF

    read -t 120 response;
}


function update_system_os {
    cat <<'EOF'

Step 1. Updating your system with the latest patches available from Ubuntu.
--------------------------------------------------------------------------------

Let's start by updating your system with the latest patches available from Ubuntu.

If you are prompted to respond y/n during the process, it is safe to type y and press 
enter to continue. 

There may be some colourful screens waiting for a response, just press enter to continue. 

Expect this phase to take a few minutes and generate a lot of lines of output. 

Press <enter> when you are ready to begin ... or wait 30 seconds and I will start by myself ...

EOF

    read -t 30 response;

    sudo apt update
    sudo apt dist-upgrade
    sudo apt autoclean
    sudo apt autoremove --purge

    cat <<'EOF'

Hello again! 

Your system has been updated with latest patches available from Ubuntu. 
We'll continue with the next step now.

EOF
}


function set_timezone_utc  {
    cat <<EOF

Step 2. Setting the timezone to UTC.
--------------------------------------------------------------------------------

We will set the timezone to UTC since some VPS hosting companies set the timezone 
to their local timezone. 

EOF
    sudo timedatectl set-timezone UTC
}


function create_user_accounts {
    cat <<'EOF'

Step 3. Create the onefinity user account and set the password
--------------------------------------------------------------------------------

We will now create the onefinity user account.

You will be prompted to set a passord, and will need to type that password 2 times.
Please choose a password of at least 8 characters. Use at least one numeral and at 
least one upper-case letter. Be sure to record the password for use in the event you 
need to login to this host from the VPS providers console. 

EOF

    getent passwd ${ONEFINITY_USERNAME} && true || sudo useradd -c "OneFinity Validator" -s /bin/bash -m ${ONEFINITY_USERNAME}
    sudo usermod -aG sudo ${ONEFINITY_USERNAME}
    sudo passwd ${ONEFINITY_USERNAME}
}


function create_sudo_rules {
    cat <<'EOF'

Step 4. Create rules to allow the onefinity user account to use the sudo command
--------------------------------------------------------------------------------

Sudo access is required by mx-chain-scripts when installing and managing nodes
on the MultiversX blockchain network.

EOF

    # getting the group name, just in case it does not match the username
    local _user=${ONEFINITY_USERNAME}
    sudo echo "${_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${_user}-ALL-NOPASSWD
}


function update_ssh_public_keys {
    cat <<'EOF'
Step 5. Add an SSH public key for the onefinity user.
--------------------------------------------------------------------------------

SSH will be configured to prevent login by password, so you will need an SSH public
key to access this host.

When prompted, paste your SSH PUBLIC KEY, and I will add it to the list of authorized
keys for the onefinity user.

EOF

    local _user=${ONEFINITY_USERNAME}
    local _user_home=$(getent passwd ${_user} | awk -F':' '{print $6}')
    local _ssh_public_key=""

    echo "Paste your SSH public key:"
    read _ssh_public_key

    
    sudo -u ${_user} mkdir -p ${_user_home}/.ssh
    sudo -u ${_user} echo "${_ssh_public_key}" >> ${_user_home}/.ssh/authorized_hosts

    sudo chown -R "$(id -u):$(id -g)" ${_user_home}/.ssh
    sudo chmod 700 ${_user_home}/.ssh
    sudo chmod 600 ${_user_home}/.ssh/authorized_hosts
}


function install_configure_ufw {
    cat <<'EOF'

Step 6. Install UFW (uncomplicated firewall) to secure your VPS server.
--------------------------------------------------------------------------------

The firewall will be installed, configured, and started.
The firewall will only allow inbound traffic on tcp/22 (SSH), and tcp/37373-38383 (MultiversX nodes).

If you see this message: "Command may disrupt existing ssh connections. Proceed with operation"
it is safe to type y and press enter to continue.

EOF

    read -t 30 -p "press <enter> when ready to configure the firewall ... " response;

    # install UFW firewall
    sudo apt -y install ufw

    # backup /etc/default/ufw before changes
    cp -p /etc/default/ufw{,-$(date "+%s").backup}

    # disable IPv6 in UFW
    sudo perl -spi -e 's/IPV6=yes/IPV6=no/g' /etc/default/ufw;

    # allow 22/tcp in for SSH communication
    sudo ufw allow 22/tcp

    # allow 37373:38383/tcp required ports for MultiversX p2p network
    sudo ufw allow 37373:38383/tcp

    # block outbound traffic on RFC-1918 address ranges 
    # from discussion in validators Telegram with thanks to @pousette
    sudo ufw deny proto tcp to 10.0.0.0/8
    sudo ufw deny proto tcp to 172.16.0.0/12
    sudo ufw deny proto tcp to 192.168.0.0/16

    sudo ufw logging on
    sudo ufw enable
}


function configure_strict_ssh {
    cat <<'EOF'

Step 7. Update the SSH configuration to make it secure.
--------------------------------------------------------------------------------

We do this by preventing root user login over SSH.
The root user will only be allowed to login from the VPS providers console. 
We prevent login by password thereby forcing login by SSH private key.

EOF

    # backup /etc/ssh/sshd_config before changes 
    cp -p /etc/ssh/sshd_config{,-$(date "+%s").backup}

    # comment the following defaults
    sudo perl -spi -e 's/^(Protocol|PermitRootLogin|PasswordAuthentication|PermitEmptyPasswords)/#\1/g;' /etc/ssh/sshd_config
    sudo cat <<'EOF' >> /etc/ssh/sshd_config

# Use only SSH Protocol 2
Protocol 2

# Prevent root user from login
# PermitRootLogin no

# Disable passsword authentication
PasswordAuthentication no
PermitEmptyPasswords no
EOF

}


## Initial host setup for OneFinity validator nodes.

# Print a welcome message and allow the user to continue or cancel.
print_welcome_message;

# Update the system from the Ubuntu package repository.
update_system_os;

# Set the timezone to UTC.
set_timezone_utc;

# Create a user account named onefinity, this account will be used to run the OneFinity validator node(s), 
# and will be the only account allowed to login to this system. 
create_user_accounts;

# Create rules to allow the onefinity user account to use the sudo command. 
create_sudo_rules;

# Update SSH public keys
# SSH will be configured to prevent login by passord, so you will need an SSH public key to access this host.
update_ssh_public_keys;

# Install UFW (uncomplicated firewall) to secure your VPS server.
# The firewall will configured to only allow inbound traffic on tcp/22 (SSH), and tcp/37373-38383 (MultiversX nodes). 
install_configure_ufw;

# Update the SSH configuration to make it secure.
# We do this by preventing root user login, preventing login by password so forcing login by SSH private key.
# We need to generatate the SSH private key first, otherwise the user will be locked-out of their host.
configure_strict_ssh;

exit;
