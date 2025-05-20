# teraform
Terraform adalah tool open source untuk membangun, mengubah dan membuat versi infrastructure dengan aman dan efisien. Biasanya dikenal dengan infrastructure as code. Terraform dibuat oleh HashiCorp.

# Core Terraform Workflow
Ada 3 tahapan inti didalam alur kerja terraform, yaitu : WRITE → PLAN → APPLY

## Write: Tulis terraform configuration dan initialize 
- Anda bisa menulis code didalam terraform configuration file ( .tf ), kemudian lakukan initialize dengan command terraform init .
- Contoh code terraform yang disimpan di dalam sebuah file main.tf:
  ```bash
  provider "aws" {
    version = "~> 3.0"
    }
    resource "aws_instance" "example" {
    ami           = "ami-005e54dee72cc1d00"
    instance_type = "t3.micro"
    tags = {
        Name = "example"
    }
  }
  ```

## Plan: Preview
-  Sebelum diterapkan ke infrastructure yang sebenarnya, anda bisa melakukan preview terlebih dahulu apa yang akan dibuat, ubah atau hapus sehingga lebih aman saat diterapkan ke infrastructure yang sebenarnya.

## Apply: Terapkan ke real infrastructure
- Setelah anda review, anda bisa menerapkan ke infrastructure yang sebenarnya dengan command terraform apply .

# Terraform Command
```bash
terraform init # Command ini wajib dijalankan pertama kali setelah anda selesai menulis code terraform anda. 
# Tujuannya untuk inisialisasi. Anda harus masuk ke directory dimana terraform configuration file dibuat. Sebagai contoh, kita membuat file dengan nama main.tf, kemudian anda jalankan terraform init di directory dimana file main.tf itu berada.

terraform plan # Sebelum anda benar-benar menerapkan perubahan infrastructure di AWS atau provider lain yang anda pilih, Anda bisa melihat terlebih dahulu perubahan apa yang akan terjadi.
# Jadi anda bisa memastikan terlebih dahulu jika perubahannya adalah sesuai dengan yang anda buat. Setelah anda menjalankan terraform init , kemudian anda bisa menjalankan terraform plan untuk preview.

terraform apply # Setelah anda menjalankan terraform init dan menjalankan terraform plan, anda bisa menerapkan perubahan tersebut ke real infrastructure anda semisal di AWS dengan menjalankan command terraform apply.
# Ketika selesai dan succeeded, anda bisa cek di AWS apakah infrastructure atau resource yang anda buat/ubah benar-benar terbuat/terubah.

terraform destroy # Anda harus berhati-hati dengan command ini, karena dengan menjalankan command terraform destroyberarti anda akan menghapus infrastructure yang anda buat.
```

# installasion teraform
- [developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  ```bash
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt-get install terraform
  ```
- windows
  ```bash
  scoop install terraforms
  terraform -help
  ```

# Membuat AWS Resource dengan Terraform
Ada beberapa requirements yang harus anda penuhi sebelum mengikuti tahap ini.

## Requirements:
- aws configure, pastikan anda memiliki akses untuk membuat resource AWS melalui api calls. Jalankan aws configure kemudian masukan Access key ID dan Secret access key serta region dimana anda akan membuat resource.
- install terraform, pastikan anda sudah menginstall terraform dengan benar

## steps
- Buat directory khusus untuk menyimpan code terraform anda. Untuk contoh kali ini saya akan membuat structure directory seperti ini:
  ```bash
    .
  └── dev
      └── main.tf
  ```
- Isikan file main.tf di directory dev dengan code berikut ini:
  ```bash
  provider "aws" {
    version = "~> 3.0"
    region  = "ap-southeast-1"
  }
  resource "aws_instance" "dev" {
    ami           = "ami-1a2b3c4d5e6f7g"
    instance_type = "t3.micro"
    tags = {
      Name          = "dev"
      Environment   = "development"
      ProvisionedBy = "terraform"
    }
  }
  ```
  ubah ami-1a2b3c4d5e6f7g dengan AMI ID yang ada di Account AWS Anda.
- Masuk ke directory dev , kemudian jalankan terraform init , dan pastikan initialisasinya berhasil.
  contoh output terraform init :
  ```bash
  Terraform has been successfully initialized!
  You may now begin working with Terraform. Try running "terraform plan" to see
  any changes that are required for your infrastructure. All Terraform commands
  should now work.
  ```
- Jika anda perhatikan, akan ada sebuah file baru yaitu terraform.tfstate , Itu merupakan terraform state file. 
  - Terraform state menyimpan informasi mengenai infrastructure anda, jadi jika ada perubahan akan di bandingakan dengan state yang ada saat ini. 
  - Karena anda tidak mendefiniskan state disimpan disuatu tempat, maka state secara default akan disimpan di lokal. 
  - Untuk manajemen state tidak akan dibahas disini, tetapi akan dibahas di tulisan selanjutnya.
- langkah selanjutnya adalah preview perubahan yang akan terjadi dengan cara menjalankan command terraform plan .
  contoh output terraform plan:
  ```bash
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    + create
  Terraform will perform the following actions:
  # aws_instance.dev will be created
    + resource "aws_instance" "dev" {
        + ami                                  = "ami-1a2b3c4d5e6f7g"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
  ...
  ...
        + instance_type                        = "t3.micro"
  ...
  ...
        + tags                                 = {
            + "Environment"   = "development"
            + "Name"          = "dev"
            + "ProvisionedBy" = "terraform"
          }
  ...
  ...
  Plan: 1 to add, 0 to change, 0 to destroy.
  ```
  Dari hasil output diatas, anda bisa tahu bahwa akan ada pembuatan 1 resource aws_instance dengan AMI ID ami-1a2b3c4d5e6f7g ,instance type t3.micro dan tags seperti pada output diatas.
- Jika anda sudah merasa sesuai dengan yang anda buat, maka sekarang saatnya menerapkannya di real AWS dengan cara menjalankan command terraform apply. 
- Untuk apply ini anda akan diminta untuk konfirmasi apakah anda yakin untuk melakukan apply. Jika anda yakin, anda bisa isikan yes jika muncul seperti ini:
  ```bash
  Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.
  Enter a value: yes
  ```
- Tunggu hingga proses pembuatan resource selesai. Jika berhasil maka akan muncul output seperti ini:
  ```bash
  aws_instance.dev: Creating...
  ...
  ...
  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
  ```
- Sekarang anda sudah berhasil membuat AWS EC2 Instance di AWS dengan terraform.
  - AWS EC2 Instance sudah terbuat, tetapi masih ada pertanyaan selanjutnya. Bagaimana jika saya ingin membuat AWS EC2 Instance-nya private only, dan terattach security group, serta saya ingin di subnet tertentu? Jawabannya ada di bawah ini.
  - Jika anda amati code di file main.tf diatas, yang di define hanya beberapa argument, yaitu ami , instance_type dan tags . Jadi argument yang tidak anda isi akan menggunakan default value. Jika anda ingin define argument lain, anda bisa lihat di link ini. Anda bisa mencobanya sendiri nanti setelah selesai mengikuti tutorial ini.

---

# Duplikasi AWS Resource dengan Terraform
Untuk menduplikasikan AWS EC2 Instance yang sudah dibuat diatas, anda cukup membuat sebuah directory baru dan copy file main.tf ke directory yang baru, kemudian anda sesuaikan.

## steps
- buat folder staging dan copy file main.tf yang ada di directory dev , kemudian paste ke directory staging . Sehingga menjadi terlihat seperti ini:
  ```
  .
  ├── dev
  │   ├── main.tf
  │   └── terraform.tfstate
  └── staging
      └── main.tf
  ```
- Sesuaikan dengan environment staging sehingga file main.tfmenjadi seperti berikut ini:
  ```
  provider "aws" {
    version = "~> 3.0"
    region  = "ap-southeast-1"
  }
  resource "aws_instance" "staging" {
    ami           = "ami-1a2b3c4d5e6f7g"
    instance_type = "t3.small"
    tags = {
      Name          = "staging"
      Environment   = "staging"
      ProvisionedBy = "terraform"
    }
  }
  ```
- Anda cukup merubah sesuai yang anda inginkan, di contoh ini saya merubah type instance dan penamaan di tags.
- Lakukan inisialisasi, masuk ke directory staging kemudian jalankan terraform init .
- Preview dengan menjalankan commandterraform plan
- contoh output terraform plan:
  ```bash
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    + create
  Terraform will perform the following actions:
  # aws_instance.staging will be created
    + resource "aws_instance" "staging" {
        + ami                                  = "ami-1a2b3c4d5e6f7g"
        + arn                                  = (known after apply)
        + associate_public_ip_address          = (known after apply)
  ...
  ...
        + instance_type                        = "t3.small"
  ...
  ...
        + tags                                 = {
            + "Environment"   = "staging"
            + "Name"          = "staging"
            + "ProvisionedBy" = "terraform"
          }
  ...
  ...
  Plan: 1 to add, 0 to change, 0 to destroy.
  ```
- Terapkan ke real infrastructure dengan menjalankan command terraform apply dan isikan yes pada form konfirmasi.
- Jika sukses maka akan terbentuk 1 instance baru dengan nama staging dan type t3.small seperti pada gamba berikut:

---

# Merubah AWS Resource dengan Terraform
Saat ini anda sudah memiliki infrastructure untuk environment development dan staging , kemudian anda akan melakukan perubahan pada infrastructure anda. Adapun perubahannya adalah sebagai berikut:

- merubah type instance dari t3.micro ke t3.small untuk environment development
  - menambah 1 resource tambahan yaitu S3 Bucket untuk environment development dan staging
- Maka, anda cukup merubah file main.tf di masing-masing environment, sehingga menjadi seperti berikut ini:

main.tf di ENVIRONMENT Development
```bash
provider "aws" {
  version = "~> 3.0"
  region  = "ap-southeast-1"
}
resource "aws_instance" "dev" {
  ami           = "ami-1a2b3c4d5e6f7g"
  instance_type = "t3.small"
  tags = {
    Name          = "dev"
    Environment   = "development"
    ProvisionedBy = "terraform"
  }
}
resource "aws_s3_bucket" "dev" {
  bucket = "sanimuhlison-dev"
  acl    = "private"
  tags = {
    Name          = "sanimuhlison-dev"
    Environment   = "development"
    ProvisionedBy = "terraform"
  }
}
```

main.tf di ENVIRONMENT Staging
```bash
provider "aws" {
  version = "~> 3.0"
  region  = "ap-southeast-1"
}
resource "aws_instance" "staging" {
  ami           = "ami-1a2b3c4d5e6f7g"
  instance_type = "t3.small"
  tags = {
    Name          = "staging"
    Environment   = "staging"
    ProvisionedBy = "terraform"
  }
}
resource "aws_s3_bucket" "staging" {
  bucket = "sanimuhlison-staging"
  acl    = "private"
  tags = {
    Name          = "sanimuhlison-staging"
    Environment   = "staging"
    ProvisionedBy = "terraform"
  }
}
```

Selanjutnya anda bisa masuk ke directory masing-masing kemudian jalankan terraform plan untuk preview dan jalankan command terraform apply untuk menerapkan ke infrastructure yang sebenarnya.

Jika anda berhasil, maka seharunya hasilnya seperti ini:
Resource AWS EC2 Instance

Jika anda ingin menambahkan resource lain, anda bisa menambahkan seperti halnya menambah resource aws_s3_bucket diatas.

Argumen tambahan untuk resource aws_s3_bucket bisa dilihat di [link ini.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

---

# Menghapus AWS Resource dengan Terraform
Suatu ketika anda ingin menghapus resource yang sudah anda buat karena untuk environment tersebut mungkin anda sudah tidak memerlukan lagi. Sebagai contoh anda ingin menghapus semua resource yang ada di environmet dev. Lantas bagaimana caranya?

- Caranya cukup mudah, anda cukup masuk ke directory dev , kemudian anda jalankan command terraform destroy , ketik yes jika diminta konfirmasi.
- Contoh output terraform destroy :
  ```bash
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    - destroy
  Terraform will perform the following actions:
  # aws_instance.dev will be destroyed
    - resource "aws_instance" "dev" {
        - ami                                  = "ami-1a2b3c4d5e6f7g" -> null
  ...
  ...
  # aws_s3_bucket.dev will be destroyed
    - resource "aws_s3_bucket" "dev" {
        - acl                         = "private" -> null
        - arn                         = "arn:aws:s3:::sanimuhlison-dev" -> null
  ...
  ...
  Plan: 0 to add, 0 to change, 2 to destroy.
  Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.
  Enter a value: yes
  ```
- tunggu hingga proses destroy selesai, jika berhasil maka seharusnya resource yang sudah di destroy tidak ada lagi untuk saat ini.
- AWS EC2 Instance
- AWS S3 Bucket