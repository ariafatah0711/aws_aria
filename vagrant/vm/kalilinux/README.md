# vagrant kali linux
## docs
- [kali linux vagrant](https://www.kali.org/docs/virtualization/install-vagrant-guest-vm/)
- [vagrant kali linux](https://portal.cloud.hashicorp.com/vagrant/discover/kalilinux/rolling)

## create Vagrantfile
```bash
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "kalilinux/rolling"

  # Gunakan bridged network (akan minta pilih adapter fisik saat vagrant up)
  config.vm.network "public_network"

  # VirtualBox specific settings
  config.vm.provider "virtualbox" do |vb|
    # Tampilkan GUI saat boot
    vb.gui = true

    # RAM VM
    vb.memory = "4096"
    vb.cpus = 2
  end

  # Provision dengan shell script
  config.vm.provision "shell", inline: <<-EOF
    sudo apt update
    sudo apt install -y crowbar
  EOF
end
```

## init
```bash
mkdir ./data

vagrant up # start
vagrant halt # down

vagrant reload # jika sudah pernah dibuat
```