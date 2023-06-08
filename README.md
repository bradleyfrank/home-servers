# Storage & Media Server

## Bootstrap

```sh
sudo useradd --create-home --user-group --shell /bin/bash --comment "Ansible user" ansible > /dev/null
sudo mkdir /home/ansible/.ssh > /dev/null
sudo chmod 0700 /home/ansible/.ssh
cat << 'EOF' | sudo tee /home/ansible/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXi9rxK1HI1v2QOrjupf6XM9evD2vKfw3msmUbWlb7n ansible@francopuccini.casa
EOF
sudo chown -R ansible:ansible /home/ansible/.ssh
cat << EOF | sudo tee /etc/sudoers.d/ansible
ansible ALL=NOPASSWD: ALL
EOF

sudo apt-get update && sudo apt-get upgrade -y
```

### Ansible: Bootstrap

```sh
ansible-playbook -i inventory/prod.ini playbooks/bootstrap.yml
```

## ZFS Setup

```sh
# Identify the disks for the zfs pool:
sudo lsblk -o NAME,SIZE,MODEL,WWN,TRAN -I8 -dn -x SIZE

# Import and upgrade pools if applicable:
sudo zpool import -f <NAME>
sudo zpool upgrade <NAME>

# Remove any existing partitions from the target disks:
for sd in sdX sdY sdZ sdN; do sudo parted -s /dev/$sd mklabel GPT; done
sudo reboot

# Create the zfs pools with a mirror vdev:
sudo zpool create data -f -o ashift=12 -O xattr=sa -O compression=lz4 -O atime=off -O recordsize=128K \
  mirror wwn-X wwn-Y mirror wwn-Z wwn-N
sudo zpool create kvm -f -o ashift=13 -O xattr=sa -O compression=lz4 -O atime=off -O recordsize=64K \
  mirror wwn-A wwn-B
```

### Ansible: Sanoid

```sh
ansible-playbook -i inventory/prod.ini playbooks/sanoid.yml
```

## Apps

### Ansible: Apps

```sh
ansible-playbook -i inventory/prod.ini playbooks/app-server.yml
```

### Plex

First run only:

1. Get Plex claim code: https://www.plex.tv/claim
2. Update `plex/docker-compose` with claim code
