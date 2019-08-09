# vagrant_PXE_Server
A vagrant box using base CentOS 7 box to set up a PXE server. Currently installs Ubuntu 19.04 but can also install any other OS

## About the project
The purpose of this project is to be able to install an OS with PXE to multiple client machines. To achieve it, we will configure a LAN, where the client machines and server will be, and route all traffic from the clients through the server (necessary for the mirrors during install and post-installation script). Our LAN uses the 192.168.0.0/24 network, so make sure your other interface (the one with internet access) isn't using the same network, or change this projects configuration to use another network (dhcp.conf and Vagrantfile files).

In the following figure you can see our architecture better.

![Image of architecture](https://github.com/UrkoLekuona/vagrant_PXE_Server/edit/master/vagrant_PXE_server.png)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Things you may need to install this project

```
* A host machine with Vagrant installed
* A host machine with two network interfaces. One of them should have internet access and the other doesn't need to be configured, as the vagrant server will configure it with DHCP
* A Linux installation disk ISO (this project is designed for ubuntu 19.04)
* A switch connected to the client machines and to the second interface of the host machine
```
### Installing

These steps assume you already have the LAN physically installed, which only consists of connecting all the client machines and the host to a switch. In case of the host machine, it will probably need a second NIC (unless you want to set up a VLAN). In my case, I use a USB to Ethernet adapter.

1. Clone the repository to the desired location in the host machine.
```
git clone 
```
2. If vagrant is configured in your path, run *vagrant up*
```
vagrant up
```
3. Vagrant will ask you to choose an interface to bridge to. You need to choose the interface that goes to your LAN (the one connected to the switch, in my case "enx00e04c681ae3").
```
==> default: Specific bridge 'choose' not found. You may be asked to specify
==> default: which network to bridge to.
==> default: Available bridged network interfaces:
1) enp2s0
2) enx00e04c681ae3
==> default: When choosing an interface, it is usually the one that is
==> default: being used to connect to the internet.
    default: Which interface should the network bridge to? 2
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: bridged
```
4. The first time the server starts up, vagrant will run the provisioning script, which takes a long time as it has to update all the packages and copy some large files, just wait until you get the prompt back.

Now the PXE server is up and running, you only need to boot your client machines, enter BIOS and PXE boot them. Everything else will be automatically done. You can always run *vagrant ssh* to connect to the PXE server and modify or test anything you need.


## Contributing

Any bug-fixes, improvements or other kinds of feedback are welcome. You can always open an issue in this project, make a pull request or even send me a personal email. Don't refrain from contacting me if you think I can help you with your installation :D.

## Authors

* **[Urko Lekuona](https://github.com/UrkoLekuona)**

See also the list of [contributors](https://github.com/UrkoLekuona/vagrant_PXE_Server/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details


