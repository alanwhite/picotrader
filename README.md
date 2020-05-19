# PicoTrader

A set of automation tools and approaches for building a cluster of Odroid C2 Arm64 servers. 

## Current Status

Applies a baseline configuration to the default Ubuntu image as shipped by HardKernel.
- Add user 'sysman' with sudo rights, as the ansible admin user
- Add ssh keys from current user on control host
- Disallow ssh directly root
- Install a firewall and allow only ssh inbound connections to the host
- Add an /etc/hosts file with all hosts names

## Ongoing Research (i.e. still to do)

Providing Software Defined Storage that clusters the available free storage on each device.
Installing and configuring Kubernetes and required components
Port multi-threaded Java spread-betting app to Dart running in containers across the cluster 

## Steps for building the cluster

1. Download the required Ubuntu operating system imagesfor the Odroid C2 nodes. In our case we have the UI image for the server appointed as the Control Workstation (CWS) and the minimal image for the other devices.
2. Flash the images to the eMMC cards on each node
3. Set the mac up as an ansible control node
4. Using Ansible apply the baseline configuration to all devices
5. Change the root password

### Setup macOS as an Ansible Control Node
Guide at https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#from-pip



