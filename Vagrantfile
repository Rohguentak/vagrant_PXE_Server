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
  config.vm.network "public_network", ip: "192.168.0.3", bridge: "choose"

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
    yum install -y vim dhcp tftp tftp-server syslinux vsftpd xinetd httpd
  
    # Edit DHCP server configuration
    cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf
    
    # Enable forwarding
    echo -ne "net.ipv4.ip_forward = 1\n" > /etc/sysctl.conf
    sysctl -p
    
    # Enable tftp in xinetd
    echo -ne "service tftp\n{\n socket_type = dgram\n protocol    = udp\n wait        = yes\n user        = root\n server      = /usr/sbin/in.tftpd\n server_args = -s /var/lib/tftpboot\n disable     = no\n per_source  = 11\n cps         = 100 2\n flags       = IPv4\n}" > /etc/xinetd.d/tftp
    
    # Set up required files
    #  -> TFTP files
    cp -va /vagrant/bootfiles/ubuntu-installer/amd64/* /var/lib/tftpboot
    mkdir /var/lib/tftpboot/pxelinux.cfg
    mkdir /var/lib/tftpboot/networkboot
    mv /var/lib/tftpboot/linux /var/lib/tftpboot/networkboot/linux
    mv /var/lib/tftpboot/initrd.gz /var/lib/tftpboot/networkboot/initrd.gz
    cp -va /vagrant/bootfiles/ldlinux.c32 /var/lib/tftpboot/ldlinux.c32
    restorecon -R /var/lib/tftpboot/
    #  -> Web server files
    cp -av /vagrant/preseed.cfg /var/www/html/preseed.cfg
    cp -av /vagrant/post_install.sh /var/www/html/post_install.sh
    chown apache:apache -R /var/www/html/
    chmod 755 -R /var/www/html/

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
    #  -> Disable SELinux? (had issues with tftp boot)
    setenforce 0
  
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
    #  -> Reload firewall rules
    firewall-cmd --reload
    SHELL
end
