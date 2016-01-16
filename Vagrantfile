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
require 'yaml'
require './lib/vagrant/os_detect.rb'

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
if not File.exist?("./site.yml")
    puts "You must create main playbook file for Ansible named 'site.yml' next to Vagrantfile! See site.example.yml for instructions\n"
    exit
end

if not File.exist?("./hosts")
    puts "You must create inventory file for Ansible named 'hosts' next to Vagrantfile! See hosts.example.txt for instructions\n"
    exit
end

settings = YAML.load_file('./site.yml')

# Main vagrant configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Minimalistic CentOS 7
    config.vm.box = "bento/centos-7.2"

    # Configure automatically updates
    config.vm.box_check_update = true
    config.vbguest.auto_update = true

    # Port forwarding
    roles = settings[0]['roles'];
    if roles.any?{|a| a['role'] == "web"}
        config.vm.network "forwarded_port", guest: 80, host: 8080      # Nginx
    end

    if roles.any?{|a| a['role'] == "postgres"}
        config.vm.network "forwarded_port", guest: 5432, host: 5432    # Postgresql
    end

    if roles.any?{|a| a['role'] == "redis"}
        config.vm.network "forwarded_port", guest: 6379, host: 6379    # Redis
    end

    if roles.any?{|a| a['role'] == "rabbitmq"}
        config.vm.network "forwarded_port", guest: 5672, host: 5672    # RabbitMQ
        config.vm.network "forwarded_port", guest: 15672, host: 15672  # Rabbitmq management console
    end

    if roles.any?{|a| a['role'] == "elastic"}
        config.vm.network "forwarded_port", guest: 9300, host: 9200    # ElasticSearch
    end

    config.vm.network "private_network", type: "dhcp"

    # Virtual box customizing
    #
    # @link http://www.virtualbox.org/manual/ch08.html
    config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = settings[0]['vars']['project_name_camel'] + " Development Environment"
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "1536"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--largepages", "on"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    end

    # Configuring firewall to enable nfs virtual folders
    config.vm.provision "shell", path: './lib/shell/firewalld.sh'

    # Mouting main website folder
    project_name_snake = settings[0]['vars']['project_name_snake']
    project_folder_local = './../' + project_name_snake + "_src";
    project_local_vm = '/var/www/' + project_name_snake;

    if not File.exist?(project_folder_local)
        puts "Project folder '#{project_folder_local}' is not found. Attemting to create"
        Dir.mkdir(project_folder_local)
        puts "Created project folder '#{project_folder_local}'."
    end

    if OS.windows?
      config.vm.synced_folder project_folder_local, project_local_vm
    else
      config.vm.synced_folder project_folder_local, project_local_vm, type: "nfs", mount_options: ['nolock,vers=3,udp,noatime,actimeo=1']
    end

    # Installing and running Ansible to provision server
    config.vm.provision "shell", inline: "if ! rpm -q epel-release-7-5 > /dev/null ; then yum localinstall -y http://mirror.logol.ru/epel/7/x86_64/e/epel-release-7-5.noarch.rpm; fi"
    config.vm.provision "shell", inline: "if ! rpm -q ansible > /dev/null ; then yum install -y ansible; fi"
    config.vm.provision "shell", inline: "chmod +x /vagrant/hosts"
    config.vm.provision "shell", keep_color:true, inline: "export PYTHONUNBUFFERED=1 && ansible-playbook /vagrant/site.yml --inventory=/vagrant/hosts"
end
