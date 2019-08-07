# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network", ip: "192.168.0.3", bridge: "asdf"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    # Update and install required packages
    yum update -y
    yum install -y vim dhcp tftp tftp-server syslinux vsftpd xinetd httpd nfs-utils
    # Edit DHCP server configuration
    cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf
    # Enable forwarding
    echo -ne "net.ipv4.ip_forward = 1\n" > /etc/sysctl.conf
    sysctl -p
    # Enable tftp in xinetd
    echo -ne "service tftp\n{\n socket_type = dgram\n protocol    = udp\n wait        = yes\n user        = root\n server      = /usr/sbin/in.tftpd\n server_args = -s /var/lib/tftpboot\n disable     = no\n per_source  = 11\n cps         = 100 2\n flags       = IPv4\n}" > /etc/xinetd.d/tftp
    # Export NFS directory
    echo -ne "/var/nfs  *(ro,sync,no_wdelay,insecure_locks,no_root_squash,insecure,no_subtree_check)" > /etc/exports
    mkdir /var/nfs/
    exportfs -a
    # Set up required files
    cp -v /vagrant/bootfiles/* /var/lib/tftpboot
    mkdir /var/lib/tftpboot/pxelinux.cfg
    mkdir /var/lib/tftpboot/networkboot
    mount -o loop /vagrant/ubuntu-19-unattended.iso /mnt/
    cp -av /mnt/* /var/nfs/
    cp /vagrant/preseed.cfg /var/www/html/preseed.cfg
    cp /vagrant/post_install.sh /var/www/html/post_install.sh
    cp /mnt/casper/initrd /var/lib/tftpboot/networkboot/
    cp /mnt/casper/vmlinuz /var/lib/tftpboot/networkboot/
    umount /mnt/
    # Edit bootparam file
    echo -ne "default menu.c32\nprompt 0\ntimeout 30\nMENU TITLE PXE Menu\nLABEL ubuntu-19.04\nMENU LABEL Ubuntu-19.04\nKERNEL /networkboot/vmlinuz\nAPPEND url=http://192.168.0.3/preseed.cfg auto=true priority=critical debian-installer/locale=en_US keyboard-configuration/layoutcode=es languagechooser/language-name=English countrychooser/shortlist=ES localechoose/supported-locales=en_US.UTF-8 boot=casper automatic-ubiquity netboot=nfs nfsroot=192.168.0.3:/var/nfs/ initrd=/networkboot/initrd \n" > /var/lib/tftpboot/pxelinux.cfg/default
    # Start and enable services
    systemctl start xinetd
    systemctl enable xinetd
    systemctl start dhcpd.service
    systemctl enable dhcpd.service
    systemctl start vsftpd
    systemctl enable vsftpd
    systemctl start firewalld
    systemctl enable firewalld
    systemctl start httpd
    systemctl enable httpd
    systemctl start nfs-server
    systemctl enable nfs-server
    # SELinux required rules
    setsebool -P allow_ftpd_full_access 1
    # Firewall configuration
    #  -> Forwarding
    firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 192.168.0.0/24
    #  -> Accept all incoming traffic 
    firewall-cmd --permanent --set-target=ACCEPT
    #firewall-cmd --add-service=ftp --permanent
    #firewall-cmd --add-service=dhcp --permanent
    #firewall-cmd --add-port=69/tcp --permanent 
    #firewall-cmd --add-port=69/udp --permanent 
    #firewall-cmd --add-port=4011/udp --permanent
    firewall-cmd --reload
    SHELL
end
