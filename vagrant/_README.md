# 👙 Vagrant - Virtual Machine Manager Simplified

## 📖 Apa Itu Vagrant?

**Vagrant** adalah tool dari HashiCorp untuk membuat dan mengelola **virtual machine (VM)** secara otomatis, cepat, dan repeatable. Vagrant menggunakan file konfigurasi (`Vagrantfile`) dan image siap pakai yang disebut **box**, tanpa perlu download & install ISO manual.

Dengan Vagrant, kamu bisa:

* Menjalankan VM secara otomatis
* Menyiapkan lingkungan dev/testing dengan satu perintah
* Reproduce lingkungan yang sama di berbagai sistem

---

## 🛠️ Cara Install (Windows)

### 1. Install [Scoop](https://scoop.sh/) (kalau belum)

```powershell
irm get.scoop.sh | iex
```

### 2. Install Vagrant

```powershell
scoop install vagrant
```

### 3. Install VirtualBox (sebagai provider VM)

```powershell
scoop install virtualbox
```

---

## ✅ Cek Instalasi

```powershell
vagrant --version
virtualbox --help
```

---

## 🚀 Cara Menggunakan Vagrant

### 1. Buat Folder Proyek

```powershell
mkdir my-vm
cd my-vm
```

### 2. Inisialisasi Vagrant

```powershell
vagrant init hashicorp/bionic64
```

> Ini akan membuat `Vagrantfile` yang menunjuk ke box Ubuntu 18.04 (bionic64)

### 3. Jalankan VM

```powershell
vagrant up
```

> Vagrant akan:
>
> * Download box dari internet (kalau belum ada)
> * Buat VM via VirtualBox
> * Provision dan nyalakan VM

### 4. Akses VM via SSH

```powershell
vagrant ssh
```

### 5. Matikan VM

```powershell
vagrant halt
```

### 6. Hapus VM (opsional)

```powershell
vagrant destroy
```

---

## 🧠 Penjelasan Singkat File `Vagrantfile`

Contoh minimal:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
end
```

Contoh konfigurasi lengkap:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
end
```

---

## 📦 Daftar Box Populer

| Box Name              | OS           |
| --------------------- | ------------ |
| `ubuntu/focal64`      | Ubuntu 20.04 |
| `ubuntu/bionic64`     | Ubuntu 18.04 |
| `debian/bullseye64`   | Debian 11    |
| `centos/7`            | CentOS 7     |
| `archlinux/archlinux` | Arch Linux   |

Cari box lain: [https://app.vagrantup.com/boxes/search](https://app.vagrantup.com/boxes/search)

---

## 📂 Folder Sinkronisasi Otomatis

* Folder proyek tempat `Vagrantfile` berada otomatis tersinkron ke dalam VM di `/vagrant`

---

## 📌 Catatan Penting

* Pastikan **VirtualBox** sudah terinstall dan tidak bentrok dengan Hyper-V
* Jika error, coba jalankan PowerShell/Terminal sebagai **Administrator**
* Jika ingin GUI, gunakan box desktop atau tambahkan GUI di provisioning

---

## 🤝 Referensi

* [Vagrant Official Docs](https://developer.hashicorp.com/vagrant)
* [Vagrant Cloud Boxes](https://app.vagrantup.com/boxes/search)
