# custom config
```bash
vagrant box add centos/7

mkdir centos
cd centos
```

create config vagrant
```bash
Vagrant.configure("2") do |config|
  # Tentukan OS box yang akan digunakan
  config.vm.box = "centos/7"

  # Konfigurasi provider VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true        # Tampilkan jendela GUI saat VM dijalankan
    vb.memory = 2048      # Alokasi RAM untuk VM (MB)
    vb.cpus = 3          # Jumlah CPU core untuk VM
  end
end
```

```bash
vagrant up
vagrant ssh
```

## check
```bash
cat /etc/os-release # check os
```