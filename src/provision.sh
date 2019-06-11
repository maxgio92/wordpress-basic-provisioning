#!/bin/bash

sudo su <<EOF
set -e
parted -a optimal /dev/xvdb mklabel msdos
parted -a optimal /dev/xvdb mkpart primary xfs 0% 100%
mkfs.xfs /dev/xvdb1
mkdir -p /mnt/data/docker
echo "/dev/xvdb1 /mnt/data xfs defaults,noatime 1 2" >> /etc/fstab
mount -a
yum install -y docker
echo "OPTIONS=\"--default-ulimit nofile=1024:4096 -g /mnt/data/docker\"" > /etc/sysconfig/docker
systemctl enable docker
usermod -aG docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir -p /mnt/data/projects
chown ec2-user: /mnt/data/projects
EOF
