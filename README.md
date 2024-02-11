# Scripts and Tools for OneFinity Validators

Here we will find scripts and tools to facilitate working with OneFinity nodes on the MultiversX blockchain network. 

## Getting started

These instructions are here to help get you up and running a OneFinity validator node on the MultiversX blockchain network.

### Prerequisites

What you need to get started. 

1. You will need an SSH client on the computer you will be using to install and manage your nodes. 

    For windows users the recommended SSH client is MobaXeterm. 
    You can download and install the 
    [MobaXterm Home Edition](https://mobaxterm.mobatek.net/download-home-edition.html). 
    To download, click the green button labeled _MobaXterm Home Edition (Installer edition)_.

    For Mac users, you can use the builtin SSH client available in the Terminal app. 

2. You will need to use your SSH client to generate an SSH keypair.

    For Windows users. [ instructions to be provided soon .... ]

    For Mac users. [ instructions to be provided soon .... ]

3. You will need a VPS hosted by a VPS provider. 

    See the requirements in the OneFinity validators Telegram chat. 

### OneFinity node VPS node setup

When you have completed the 3 requirements above you will be ready to get started.  

The OneFinity host setup script will prepare the new VPS host by completing a few adminstration tasks for you.

1. Update the system from the Ubuntu package repository.
1. Set the timezone to UTC.
1. Create a user account named onefinity, and prompt you to set the password.
1. Create rules to allow the onefinity user account to use the sudo command.
1. Add your SSH public key to the authorized_keys of the onefinity user.
1. Install and configure UFW (uncomplicated firewall) to secure your VPS host.
1. Update the SSH configuration to make it secure by preventing login via password.
1. Prompt you to restart the system for changes to take effect.

To run the script, login to your VPS host from your SSH client.

Copy the following line. Then paste it to the terminal window by pressing \<shift+insert\>, then press \<enter\> to start the process. 

~~~
curl -sk -O https://raw.githubusercontent.com/frankf1957/onefinity/main/onefinity-host-setup.sh && bash onefinity-host-setup.sh
~~~

When the script is finished it will prompt you to restart the host for changes to take effect.

Press enter and the remote system will be restarted and your SSH session will be disconnected. 

Wait a minute or two, then you can login as the onefinity user, and continue by installing the MultiversX node. 


