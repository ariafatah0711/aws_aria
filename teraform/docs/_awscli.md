# windows
```bash
scoop install aws

aws --version
aws configure
# AWS Access Key ID
# AWS Secret Access Key
# Region default (misal: ap-southeast-1)
# Output format (misal: json)
```

sebelum memasukan key perlu buat user IAM terlebih dahulu
# create user dulu di iam
- buat user dan tambahkan access administrator access
- trus buat secret keys
```
🛠 Kalau user sudah dibuat dan kamu lupa buat access key:
Tenang, kamu bisa buat access key manual:
Buka IAM Console → https://console.aws.amazon.com/iam/
Klik menu Users → klik nama user kamu (terraform-user)
Pilih tab Security credentials
Scroll ke bagian Access keys
Klik “Create access key”
Pilih:
Use case: Command Line Interface (CLI) atau Programmatic access
Klik Next dan Create access key
SIMPAN Access Key ID dan Secret Access Key (cuma muncul 1x)
```

aws sts get-caller-identity