#!/bin/bash
# run on 1st master node

sudo swapoff -a

sudo kubeadm init --control-plane-endpoint 192.168.0.200 --upload-certs --pod-network-cidr=10.244.0.0/16

# set sysman up to run kubelet
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

  kubeadm join 192.168.0.200:6443 --token p3zdl5.ye8ze8e18fhv6na7 \
    --discovery-token-ca-cert-hash sha256:660d601609742110c2dea3ab58f140e136085a8a0c1f108851bd6ae42cd33bf3 \
    --control-plane --certificate-key 0050dc7d1c4dda1a3d29661273336d678778be786b685b03a35c751b27cb6758

46sr11.kej7tq0d9xa5qzab
e9225562e0dec4af1d2eecfab290325a8cc908c144e886f6166b344af65e6794

  kubeadm join 192.168.0.200:6443 --token p3zdl5.ye8ze8e18fhv6na7 \
    --discovery-token-ca-cert-hash sha256:660d601609742110c2dea3ab58f140e136085a8a0c1f108851bd6ae42cd33bf3
