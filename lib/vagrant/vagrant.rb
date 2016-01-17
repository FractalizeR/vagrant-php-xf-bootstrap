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

module Vagrant
    def Vagrant.setupNetwork(roles)
        vagrantApiVersion = "2"
        Vagrant.configure(vagrantApiVersion) do |config|
            # Port forwarding
            if roles.any?{|a| a['role'] == "web"}
                config.vm.network "forwarded_port", guest: 80, host: 8080
            end

            if roles.any?{|a| a['role'] == "postgres"}
                config.vm.network "forwarded_port", guest: 5432, host: 5432
            end

            if roles.any?{|a| a['role'] == "mysql"}
                config.vm.network "forwarded_port", guest: 3306, host: 3306
            end

            if roles.any?{|a| a['role'] == "redis"}
                config.vm.network "forwarded_port", guest: 6379, host: 6379
            end

            if roles.any?{|a| a['role'] == "rabbitmq"}
                config.vm.network "forwarded_port", guest: 5672, host: 5672    # RabbitMQ
                config.vm.network "forwarded_port", guest: 15672, host: 15672  # RabbitMQ management console
            end

            if roles.any?{|a| a['role'] == "elastic"}
                config.vm.network "forwarded_port", guest: 9300, host: 9200
            end

            config.vm.network "private_network", type: "dhcp"
            config.vm.provision "shell", path: File.dirname(__FILE__) + '/../shell/firewalld.sh'
        end
    end

    def Vagrant.mountProjectSources(settings)
        vagrantApiVersion = "2"
        Vagrant.configure(vagrantApiVersion) do |config|
            project_name_snake = settings['vars']['project_name_snake']
            project_folder_local = './../' + project_name_snake + "_src";
            project_local_vm = '/var/www/' + project_name_snake;

            if not File.exist?(project_folder_local)
                puts "Project folder '#{project_folder_local}' is not found. Attemting to create"
                Dir.mkdir(project_folder_local)
                puts "Created project folder '#{project_folder_local}'."
            end

            if OSDetect.windows?
              config.vm.synced_folder project_folder_local, project_local_vm
            else
              config.vm.synced_folder project_folder_local, project_local_vm, type: "nfs", mount_options: ['nolock,vers=3,udp,noatime,actimeo=1']
            end
        end
    end
end
