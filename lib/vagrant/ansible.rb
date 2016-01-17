# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# This project is maintained by:
#  _    ____          ___      __               ____             __
# | |  / / /___ _____/ (_)____/ /___ __   __   / __ \____ ______/ /________  ___________  __  ____  __
# | | / / / __ `/ __  / / ___/ / __ `/ | / /  / /_/ / __ `/ ___/ __/ ___/ / / / ___/ __ \/ / / / / / /
# | |/ / / /_/ / /_/ / (__  ) / /_/ /| |/ /  / _, _/ /_/ (__  ) /_/ /  / /_/ (__  ) / / / /_/ / /_/ /
# |___/_/\__,_/\__,_/_/____/_/\__,_/ |___/  /_/ |_|\__,_/____/\__/_/   \__,_/____/_/ /_/\__, /\__, /
#                                                                                   /____//____/
#
# Email: FractalizeR@yandex.ru, vladislav.rastrusny@gmail.com
# http://www.fractalizer.ru
#
# This work is licensed under the Apache 2.0
# United States License. To view a copy of this license, visit
# http://www.apache.org/licenses/LICENSE-2.0
# or send a letter to The Apache Software Foundation Dept. 9660 Los Angeles, CA 90084-9660 U.S.A.
#

module Ansible
    def Ansible.ensureAnsibleFilesPresent
        if not File.exist?("./site.yml")
            raise "You must create main playbook file for Ansible named 'site.yml' next to Vagrantfile! See site.example.yml for instructions\n"
        end

        if not File.exist?("./hosts")
            raise "You must create inventory file for Ansible named 'hosts' next to Vagrantfile! See hosts.example.txt for instructions\n"
        end
    end

    def Ansible.install
        vagrantApiVersion = "2"
        Vagrant.configure(vagrantApiVersion) do |config|
            config.vm.provision "shell", inline: "if ! rpm -q epel-release-7-5 > /dev/null ; then yum localinstall -y http://mirror.logol.ru/epel/7/x86_64/e/epel-release-7-5.noarch.rpm; fi"
            config.vm.provision "shell", inline: "if ! rpm -q ansible > /dev/null ; then yum install -y ansible; fi"
            config.vm.provision "shell", inline: "chmod +x /vagrant/hosts"
            config.vm.provision "shell", keep_color:true, inline: "export PYTHONUNBUFFERED=1 && ansible-playbook /vagrant/site.yml --inventory=/vagrant/hosts"
        end
    end
end