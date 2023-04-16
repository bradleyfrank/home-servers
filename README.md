# Storage & Media Server

## Bootstrap

Set desired IP address: `hostIP="192.168.1.XXX"`

```sh
# Remove pre-existing configs
sudo rm /etc/netplan/00-installer-config*

# Install static config
cat << EOF | sudo tee /etc/netplan/00-home.conf
network:
  ethernets:
    $(ip --brief -4 address show | grep -E '^e[n|m]' | awk '{print $1}'):
      dhcp4: no
      addresses: [$hostIP/24]
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1]
  version: 2
  renderer: NetworkManager
EOF
```

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
```

## Packages

```sh
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install zfsutils-linux
```

## File System

```sh
# Identify the disks for the zfs pool:
sudo lsblk -o NAME,SIZE,MODEL,WWN,TRAN -I8 -dn -x SIZE

# Import and upgrade pools if applicable:
sudo zpool import -f <NAME>
sudo zpool upgrade <NAME>

# Remove any existing partitions from the target disks:
for sd in sdX sdY sdZ sdN; do sudo parted -s /dev/$sd mklabel GPT; done
sudo reboot

# Create the zfs pool with a mirror vdev:
zpool create VDEV_NAME -f -o ashift=12 -O xattr=sa -O compression=lz4 -O atime=off -O recordsize=128K \
  mirror wwn-X wwn-Y mirror wwn-Z wwn-N
```

## Apps

### Plex

First run only:

1. Get Plex claim code: https://www.plex.tv/claim
2. Update `plex/docker-compose` with claim code
