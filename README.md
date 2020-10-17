# PicoTrader

A set of automation tools and approaches for building and managing a cluster of Odroid C2 Arm64 servers. 

## Current Status

Applies a baseline configuration to each host, over the default Ubuntu image as shipped by HardKernel.
- Add user 'sysman' with sudo rights, as the ansible admin user
- Add ssh keys from current user on control host
- Disallow ssh directly to root
- Install a firewall and allow only ssh inbound connections to the host
- Set the hostname 
- Add an /etc/hosts file with all hosts names
- Installs, configures and starts Docker container runtime
- Opens firewall ports for k8s
- Configures ipv4 forwarding
- Disable swap
- Builds a loadbalancer for a shared IP 192.168.0.200
- Installs and configures HAProxy for the k8s api server on port 6443 on the control plane


Provides the ability to reinstall the default minimal.img to the eMMC card on a host, useful for when you've mangled the config and want to start again
- run the rebuild.yaml playbook
- run the baseline config again

Utility admin playbooks:
- rootpw.yaml: change the default root password on all hosts
- aptupdate.yaml: update software on all hosts
- bootfromtftp.yaml: moves a boot.ini into place so next reboot will load linux from the tftp server instead of the eMMC card
- bootfromemmc.yaml: undoes the above, moves the boot.ini saved by bootfromtftp.yaml back into play

## Ongoing Research (i.e. still to do)

- Providing Software Defined Storage that clusters the available free storage on each device.
- Install container runtime from Docker
- Installing and configuring Kubernetes and required components (microk8s / k3s / k8s )
- Deciding on database inside/outside k8s
- Port multi-threaded Java spread-betting app to Dart running in containers across the cluster 

## Steps for building the cluster

1. Download the required Ubuntu operating system images for the Odroid C2 nodes. In our case we have the UI image for the server appointed as the Control Workstation (CWS) and the minimal image for the other devices.
2. Flash the images to the eMMC cards on each node
3. Set the mac up as an ansible control node
4. Using Ansible apply the baseline configuration to all devices
5. Change the root password

### Setup macOS as an Ansible Control Node
Guide at https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#from-pip

### Setup macOS as a tftp server
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist

Create a directory 'c2' in /private/tftpboot to hold the split minimal image files, and 'c2/boot' to hold files for tftp booting a server. These are the files that exist in the /media/boot mount point once a host is built and baselined.

# Examples of running playbooks
## site.yaml
ansible-playbook -i hosts.yaml site.yaml -u root -k

Run this way, when a server is running a fresh install of the HardKernel Ubuntu image, it will use the shipped root user credentials and prompt for the password. Part of the setup creates a user 'sysman' which should be used for any future reruns or management, because part of the functionality of this workflow is it locks down direct ssh using the root user.

ansible-playbook -i hosts.yaml site.yaml -u sysman -b

Use this syntax to rerun if necessary, using the sysman user created during any prior run.

## bootfromtftp.yaml
ansible-playbook bootfromtftp.yaml -e "target=pico4" -i hosts.yaml -u sysman

This uses the sysman user (we set up in baselining a host) to copy across the config/boot.ini.tftp file so that the next time the host is rebooted, it doesn't use the linux images in the boot partition but goes and gets them from the tftp server (the mac in our case)

It saves aside the default boot.ini into boot.ini.emmc so we can revert behaviour when needed.

## bootfromemmc.yaml
ansible-playbook bootfromemmc.yaml -e "target=pico4" -i hosts.yaml -u sysman

Copies the default boot.ini saved when we've run the bootfromtftp.yaml so that next boot the server will boot from the image installed on the eMMC card.

## rebuild.yaml (tbd)
ansible-playbook rebuild.yaml -e "target=pico4" -i hosts.yaml -u sysman

Put in place a specialised boot.ini file so that the next time the host is rebooted, it will copy down the default minimal image as provided by HardKernel to the eMMC card, and reboot from that image. The server is effectively now running a fresh install, having overwritten any customisations or configuration that had been made.

A good thing to do next would be to baseline the server again ...
ansible-playbook -i hosts.yaml site.yaml -u root -k

Will fail for every host in the inventory except the one(s) needing baselined, as it will try to ssh directly to root.

## Some useful ansible commands

Reboot all nodes
ansible all -i hosts.yaml -m shell -a "reboot" -u sysman -b

Shutdown all nodes
ansible all -i hosts.yaml -m shell -a "shutdown -F now" -u sysman -b

# Knowledge Base
## How do Odroid C2 Servers Boot
They have enough intelligence on the board to read the first few blocks of an eMMC card into memory and execute it, i.e. a bootstrap loader. If there's no eMMC or no bootloader there, it tries the SD card slot.

The image format has the bootloader first then 2048 blocks in the FAT32 filesystem where uboot reads boot.ini, loads up the linux image there and eventually mounts the next partition, which is ext4 formatted as the persistent root filesystem.

By hooking into boot.ini we can download new contents for the eMMC card, or download a kernel from a tftp server and boot from that. As installed the boot.ini will load the kernel and use the root filesystem on the eMMC card.
