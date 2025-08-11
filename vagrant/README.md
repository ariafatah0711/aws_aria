## setup
- [0-setup](./0_setup.md)
- [1-init alpine](./1_init_alpine.md)
- [2-custom config](./2_custom_config.md)

- [vagrant_box_list](https://portal.cloud.hashicorp.com/vagrant/discover)

# list command
## Dasar
```bash
vagrant init <box>          # bikin Vagrantfile untuk box tertentu
vagrant up                  # nyalakan VM (buat dan boot VM kalau belum ada)
vagrant halt                # matikan VM
vagrant destroy             # hapus VM (tapi box-nya tetap ada di cache)
vagrant ssh                 # masuk ke VM via SSH
vagrant status              # cek status VM
vagrant global-status       # lihat semua VM dari semua project
```

## Box Management
```bash
vagrant box list                      # daftar semua box yang sudah di-download
vagrant box add <name> <url/path>      # tambahkan box manual dari file atau URL
vagrant box remove <name>              # hapus box dari cache lokal
vagrant box update                     # update box ke versi terbaru
```

## Provision & Config
```bash
vagrant reload              # restart VM + baca ulang konfigurasi Vagrantfile
vagrant provision           # jalankan ulang provisioning script di VM
```

## Debug / Lainnya
```bash
vagrant plugin list         # lihat plugin Vagrant yang terpasang
vagrant plugin install <p>  # install plugin
vagrant ssh-config          # lihat konfigurasi SSH untuk VM ini
vagrant version             # cek versi Vagrant
```