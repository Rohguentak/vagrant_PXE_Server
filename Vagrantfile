Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "public_network", ip: "192.168.0.3", bridge: "choose"
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
    cp -av /vagrant/manual_config.sh /var/www/html/manual_config.sh
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
