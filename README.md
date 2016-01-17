```
This project is maintained by:
 _    ____          ___      __               ____             __
| |  / / /___ _____/ (_)____/ /___ __   __   / __ \____ ______/ /________  ___________  __  ____  __
| | / / / __ `/ __  / / ___/ / __ `/ | / /  / /_/ / __ `/ ___/ __/ ___/ / / / ___/ __ \/ / / / / / /
| |/ / / /_/ / /_/ / (__  ) / /_/ /| |/ /  / _, _/ /_/ (__  ) /_/ /  / /_/ (__  ) / / / /_/ / /_/ /
|___/_/\__,_/\__,_/_/____/_/\__,_/ |___/  /_/ |_|\__,_/____/\__/_/   \__,_/____/_/ /_/\__, /\__, /
                                                                                  /____//____/
Email: FractalizeR@yandex.ru, vladislav.rastrusny@gmail.com
http://www.fractalizer.ru

This work is licensed under the Apache 2.0
United States License. To view a copy of this license, visit
http://www.apache.org/licenses/LICENSE-2.0
or send a letter to The Apache Software Foundation Dept. 9660 Los Angeles, CA 90084-9660 U.S.A.
```

Intro
========================

This is a vagrant deployment skeleton to quickly bootstrap web development.

It can quickly install and configure for you the following services:

 - CentOS 7 OS
 - PHP 7 + XDebug
 - Nginx
 - PostgreSQL
 - Redis
 - RabbitMQ
 - ElasticSearch


Installation
========================

The intended folder structure is as such:

```
 - <root folder>
 |______ vagrant-bootstrap
 |______ <project_sources_folder>
```

So, to quickly bootstrap your project you should do the following:

 - Go to your projects directory
 - Create project directory
 - Execute `git clone --recursive https://github.com/FractalizeR/vagrant-bootstrap.git`. Mind `--recursive` switch to clone with submodules!
 - Execute `git clone --recursive https://github.com/<YOUR_PROJECT>/<YOUR_REPO>`
 - Go to `vagrant-bootstrap` directory and make copies of `*.example.*` files, removing `.example` part from the name (`hosts.example` => `hosts`, `site.example.yml` => `site.yml` etc).
 - Edit renamed files making adjustments suitable for your project
 - Execute `vagrant up`.

Now your project is alive and kicking!

Details
========================
If you change something in your previously `.example.*` files, you will have to run `vagrant provision` for changes to make effect

Troubleshooting
========================

  - There can be VirtualBox problems setting network adapter. If you see the following error message: "A host only network interface you're attempting to configure via DHCP already has a conflicting host only adapter with DHCP enabled. The DHCP on this adapter is incompatible with the DHCP settings." Try the following commands:
```bash
VBoxManage hostonlyif create
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0
```

That might not work. In this case you can go to Virtual Box -> File -> Preferences -> Network, remove all network interfaces and let Vagrant reconfigure Virtual box himself.

 - If you have an error about rsync installation, download and install Cygwin https://cygwin.com/install.html and put Cygwin's bin folder (C:\cygwin64\bin\ by default) into PATH variable. Usually vagrant falls back to rsync when vbguest plugin fails to install VirtualBox Guest Additions. See below

 - If VirtualBox Guest Additions installation failed at your VM, it usually means, that kernel packages are [incorrectly updated](http://unix.stackexchange.com/questions/170089/does-centos-7-incorrectly-sort-kernel-menu-entries-in-grub-cfg). In this case you should manually SSH into your VM, check with yum which kernel version is currently the latest (`yum list kernel*`), install it with `sudo yum install kernel-3.10.0-327.4.4.el7`, `sudo yum install kernel-devel-3.10.0-327.4.4.el7` and `sudo yum install kernel-headers-3.10.0-327.4.4.el7`.

 - If Vagrant VBGuest constantly reports about versions of VirtualBox Guest Additions to be different on host and guest, manually go to [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads) and redownload/reinstall latest (or previous, if you have latest already) VB package.