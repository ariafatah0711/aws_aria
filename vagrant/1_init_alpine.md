# vagrant
## 1. init vm
```bash
mkdir alpine
cd alpine
# path folder ini untuk vmnya

# Pakai Alpine Linux (ringan banget)
vagrant init generic/alpine317

# Start VM
vagrant up  
```

> vagrant init → bikin file konfigurasi Vagrantfile.
vagrant up → download box (VM image) & jalankan.

## connect
```bash
# Masuk ke dalam VM
vagrant ssh
```
or manual with cred vagrant:vagrant

> vagrant ssh → masuk ke VM via terminal.

## more
```bash
vagrant halt # stop vm
vagrant destroy # delete vm
vagrant box remove generic/alpine317
```