# -*- mode: ruby -*-
# vi: set ft=ruby :

# There can be VirtualBox problems setting network adapter on Linux. If you see the following error message:
# "A host only network interface you're attempting to configure via DHCP
# already has a conflicting host only adapter with DHCP enabled. The
# DHCP on this adapter is incompatible with the DHCP settings."
#
# Try the following commands:
# VBoxManage hostonlyif create
# VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0

require 'rubygems'
require 'digest'
require './lib/os_detect.rb'

# Configuration files
VAGRANTFILE_API_VERSION = "2"
REQUIREMENTS = ["vagrant-vbguest"]

# Check plugin requirements
REQUIREMENTS.each do |pluginName|
  unless Vagrant.has_plugin?(pluginName)
    raise 'Vagrant plugin <%s> must be installed!' % pluginName
  end
end

# Ansible file checks
if not File.exist?("./provision/site.yml")
  puts "You must create main playbook file for Ansible named 'site.yml' next to Vagrantfile!\n"
  exit
end

if not File.exist?("./provision/hosts")
  puts "You must create inventory file for Ansible named 'hosts' next to Vagrantfile!\n"
  exit
end

# Main vagrant configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Minimalistic CentOS 7
  config.vm.box = "fhteam/centos-7.0-x86_64-minimal"

  # Configure automatically updates
  config.vm.box_check_update = true
  config.vbguest.auto_update = false

  # Port forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8080      # Nginx
  config.vm.network "forwarded_port", guest: 5432, host: 5432    # Postgresql
  config.vm.network "forwarded_port", guest: 6379, host: 6379    # Redis
  config.vm.network "forwarded_port", guest: 5672, host: 5672    # RabbitMQ
  config.vm.network "forwarded_port", guest: 9300, host: 9200    # ElasticSearch
  config.vm.network "forwarded_port", guest: 15672, host: 15672  # Rabbitmq management console

  config.vm.network "private_network", type: "dhcp"

  # Virtual box customizing
  #
  # @link http://www.virtualbox.org/manual/ch08.html
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.name = "ThirisCart Development Environment"
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "1536"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--largepages", "on"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]

  end

  if OS.windows?
    config.vm.synced_folder './../ThirisCart', '/var/www/thiriscart'
  else
    config.vm.synced_folder './../ThirisCart', '/var/www/thiriscart', type: "nfs", mount_options: ['nolock,vers=3,udp,noatime,actimeo=1']
  end


  config.vm.provision "shell", inline: "if ! rpm -q epel-release-7-5 > /dev/null ; then yum localinstall -y http://mirror.logol.ru/epel/7/x86_64/e/epel-release-7-5.noarch.rpm; fi"
  config.vm.provision "shell", inline: "if ! rpm -q ansible > /dev/null ; then yum install -y ansible; fi"
  config.vm.synced_folder './provision', '/vagrant/provision', mount_options: ["fmode=666"]
  config.vm.provision "shell", keep_color:true, inline: "export PYTHONUNBUFFERED=1 && ansible-playbook /vagrant/provision/site.yml --inventory=/vagrant/provision/hosts"
end
