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

module VirtualBox
    def VirtualBox.configureBox(baseBox)
        vagrantApiVersion = "2"
        Vagrant.configure(vagrantApiVersion) do |config|
            # Minimalistic CentOS 7
            config.vm.box = baseBox

            # Configure automatically updates
            config.vm.box_check_update = true
            config.vbguest.auto_update = true
        end
    end

    def VirtualBox.configureVM(projectName)
        vagrantApiVersion = "2"
        Vagrant.configure(vagrantApiVersion) do |config|
            # http://www.virtualbox.org/manual/ch08.html
            config.vm.provider "virtualbox" do |vb|
              vb.gui = false
              vb.name = projectName + " Development Environment"
              vb.customize ["modifyvm", :id, "--cpus", "2"]
              vb.customize ["modifyvm", :id, "--memory", "1536"]
              vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
              vb.customize ["modifyvm", :id, "--largepages", "on"]
              vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
            end
        end
    end
end