#!/bin/bash
apt update -y
apt install -y git nginx
rm -rf /var/www/html
git clone https://github.com/ariafatah0711/linktree /var/www/html
systemctl restart nginx