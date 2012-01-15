Vagrant::Config.run do |config|
  config.vm.box = "opscode-centos-5"

  config.vm.box_url = "http://opscode-vagrant-boxes.s3.amazonaws.com/centos5-gems.box"

  # Nasty hacks to make the VM work - nowt too dangerous
  config.vm.provision :shell, :inline => "grep rvm /etc/group || groupadd rvm"
  config.vm.provision :shell, :inline => "rm -f /etc/yum.repos.d/elff*"
  config.vm.provision :shell, :inline => "yum clean all"
  config.vm.provision :shell, :inline => "setenforce 0"

  # Can take ages to boot due to bloated stack
  config.ssh.max_tries = 20
  config.ssh.timeout = 30

  config.vm.forward_port "http", 80, 8080

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.add_role "yumtags"
  end

end