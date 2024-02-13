# Scripts and Tools for OneFinity Validators

Here we will find scripts and tools to facilitate working with OneFinity nodes on the MultiversX blockchain network. 

## Getting started

These instructions are here to help get you up and running a OneFinity validator node on the MultiversX blockchain network.

1. You will need an SSH client on the computer you will be using to install and manage your nodes. 

    For windows users the recommended SSH client is MobaXeterm. 
    You can download and install the 
    [MobaXterm Home Edition](https://mobaxterm.mobatek.net/download-home-edition.html). 
    To download, click the green button labeled _MobaXterm Home Edition (Installer edition)_.

    For Mac users, you can use the builtin SSH client available in the Terminal app. 

1. You will need to use your SSH client to generate an SSH keypair.

    For Windows users. [ instructions to be provided soon .... ]

    For Mac users. [ instructions to be provided soon .... ]

1. You will need a VPS hosted by a VPS provider. 

    See the requirements in the OneFinity validators Telegram chat. 

1. Optional for now, but you will need to create a GitHub user account and create a personal access token (PAT). 

    GitHub is where the source code for MultiversX nodes is hosted. 
    GitHub has implemented IP connection throttling for non GitHub users pulling from GitHub repos. 
    This can cause issues pulling down updates especially for validators when updating their nodes running on multiple hosts. 
    By creating a GitHub user account and a personal access token we can be assured that we do not get rate limited when updating our nodes. 
    Be sure to record your personal access token in your notes because it will be shown only once and you will need it later when you are ready to download and install your MultiversX node. 

    - Signup here to [create your GitHub account](https://github.com/signup)

    - Learn about [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#about-personal-access-tokens)

    - Create a [fine-grained personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)

## New VPS host setup

The OneFinity host setup script will prepare the new VPS host by completing a few adminstration tasks for you.

1. Update the system from the Ubuntu package repository.
1. Set the timezone to UTC.
1. Create a user account named onefinity, and prompt you to set the password.
1. Create rules to allow the onefinity user account to use the ```sudo``` command.
1. Prompt you for your SSH public key and add the key to the ```.ssh/authorized_keys``` file of the onefinity user.
1. Update the SSH configuration to make it secure by preventing login via password.
1. Install and configure UFW (uncomplicated firewall) to secure your VPS host.
1. Prompt you to restart the system for changes to take effect.

To run the script, login to your VPS host from your SSH client.

Copy the following line. Then paste it to the terminal window by pressing \<shift+insert\>, then press \<enter\> to start the process. 

~~~
curl -sk -O https://raw.githubusercontent.com/frankf1957/onefinity/main/onefinity-host-setup.sh && bash onefinity-host-setup.sh
~~~

When the script is finished it will prompt you to restart the host for changes to take effect.

Press enter and the remote system will be restarted and your SSH session will be disconnected. 

Wait a minute or two, then you can login as the onefinity user, and continue by installing the MultiversX node. 

## Install and configure host monitoring

Netdata is a free and open-source monitoring agent that collects thousands of hardware and software metrics from any physical or virtual system (Netdata calls them nodes). These metrics are organized in an easy-to-use and navigate interface.

You can connect to the monitoring agent on your physical or virtual system at port 19999, or login to [Netdata.cloud](https://www.netdata.cloud/)
Together with [Netdata.cloud](https://www.netdata.cloud/), you can monitor your entire infrastructure in real time and troubleshoot problems that threaten the health of your nodes.

View the [Netdata Dashboard live-demo](https://app.netdata.cloud/spaces/netdata-demo/rooms/all-nodes/overview) for a preview of what you get when you install this amazing monitoring agent.

### Get started with Netdata

Install the open-source monitoring agent on physical/virtual systems running most Linux distributions (Ubuntu, Debian, CentOS, and more), container platforms (Kubernetes clusters, Docker), and many other operating systems, with no sudo required.

You can read about installation here,
[Install Netdata with kickstart.sh](https://learn.netdata.cloud/docs/installing/one-line-installer-for-all-linux-systems)
or run the kickstart installer from the command line by pasting the following one-liner in your terminal window then press \<enter\> to start the process.

~~~
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --disable-telemetry
~~~


