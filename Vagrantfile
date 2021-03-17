# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

BOX_VERSION = "1.0"

MASTER_NAME = "master"
NODE_NAME_PREFIX = "node"

Vagrant.configure("2") do |config|

    config.vm.define "master" do |master|
        master.vm.box = "ahmetkotan/kubernetes"
        master.vm.box_version = BOX_VERSION

        master.vm.hostname = MASTER_NAME
        master.vm.network "private_network", ip: "192.168.224.2"

        master.vm.provision "shell", inline: "echo '127.0.1.1 #{MASTER_NAME}' >> /etc/hosts"
        master.vm.provision "shell", inline: "echo 'cd /vagrant' >> ~/.bashrc", privileged: false
        # master.vm.provision "file", source: "installation.sh", destination: "installation.sh"

        master.vm.provider "virtualbox" do |vb|
            vb.memory = "2048"
            vb.cpus = 2
        end
    end

    (1..2).each do |i|

        config.vm.define "#{NODE_NAME_PREFIX}#{i}" do |node|
            node.vm.box = "ahmetkotan/kubernetes"
            node.vm.box_version = BOX_VERSION

            node.vm.hostname = "#{NODE_NAME_PREFIX}#{i}"
            node.vm.network "private_network", ip: "192.168.224.#{i+2}"

            node.vm.provision "shell", inline: "echo '127.0.1.1 #{NODE_NAME_PREFIX}#{i}' >> /etc/hosts"
            node.vm.provision "shell", inline: "route add 10.96.0.1 gw 192.168.224.2"
            node.vm.provision "shell", inline: "echo 'KUBELET_EXTRA_ARGS=--node-ip=192.168.224.#{i+2}' | sudo tee /etc/default/kubelet > /dev/null"
            node.vm.provision "shell", inline: "echo 'cd /vagrant' >> ~/.bashrc", privileged: false

            node.vm.provider "virtualbox" do |vb|
                vb.memory = "2048"
                vb.cpus = 1
            end
        end
    end

end
