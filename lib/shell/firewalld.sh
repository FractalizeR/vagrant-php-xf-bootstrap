#!/usr/bin/env bash
# Enabling NFS file sharing for Vagrant
systemctl enable firewalld.service
systemctl start firewalld.service
firewall-cmd --zone=internal --change-interface=vboxnet0
firewall-cmd --permanent --zone=internal --add-service=nfs
firewall-cmd --permanent --zone=internal --add-service=rpc-bind
firewall-cmd --permanent --zone=internal --add-service=mountd
firewall-cmd --permanent --zone=internal --add-port=2049/udp
firewall-cmd --reload
