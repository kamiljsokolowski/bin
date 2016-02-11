# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
nodes = YAML.load_file('LAB.yml')

Vagrant.configure(2) do |config|

  # mgmt
  nodes.each do |nodes|
      config.vm.define nodes["name"] do |node|
          node.vm.box = nodes["box"]
          node.vm.hostname = nodes["name"]
          node.vm.box_check_update = nodes["check_updates"]
          node.vm.network nodes["net"], ip: nodes["ip"]
          if nodes["forward_host_port"] and nodes["forward_guest_port"]
            node.vm.network "forwarded_port", guest: nodes["forward_host_port"], host: nodes["forward_guest_port"]
          end
          node.vm.provider "virtualbox" do |vb|
             vb.memory = nodes["mem"]
          end
          if nodes["script"]
            node.vm.provision "shell", path: nodes["script"], privileged: false
          end
      end
  end

end

