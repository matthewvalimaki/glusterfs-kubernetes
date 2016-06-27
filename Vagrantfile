# -*- mode: ruby -*-
# vi: set ft=ruby :

# use virtualbox of available providers automatically
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(2) do |config|
  config.vm.box = "box-cutter/ubuntu1604"

  # VBox configuration
  config.vm.provider "virtualbox" do |vb|
	# Display the VirtualBox GUI when booting the machine
	vb.gui = false
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee -a /etc/apt/sources.list.d/docker.list
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  
    apt-get update
    apt-get install -y docker-engine
    apt-get dist-upgrade -y
    apt-get autoremove -y

    curl -o /usr/bin/kubectl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/linux/amd64/kubectl
    chmod +x /usr/bin/kubectl
    
    usermod -aG docker vagrant
    
    service docker start
  SHELL
end
