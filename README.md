# Storage & Media Server

## Bootstrap

Set desired IP address: `hostIP="192.168.1.XXX"`

```sh
cat << EOF > /etc/netplan/00-home.conf
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
```

```sh
useradd --create-home --user-group --shell /bin/bash --comment "Ansible user" deploy > /dev/null
mkdir /home/deploy/.ssh > /dev/null && chmod 0700 /home/deploy/.ssh
cat << 'EOF' > /home/deploy/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXi9rxK1HI1v2QOrjupf6XM9evD2vKfw3msmUbWlb7n ansible@francopuccini.casa
EOF
chown -R deploy:deploy /home/deploy/.ssh
cat << EOF > /etc/sudoers.d/deploy
deploy ALL=NOPASSWD: ALL
EOF
```

## File System

```sh
# Identify the disks for the zfs pool:
lsblk -o NAME,SIZE,MODEL,WWN -I8 -dn -x SIZE

# Remove any existing partitions from the target disks:
for sd in sdX sdY sdZ sdN; do sudo parted -s /dev/$sd mklabel GPT; done
sudo reboot

# Create the zfs pool with a mirror vdev:
zpool create VDEV_NAME -f -o ashift=12 -O xattr=sa -O compression=lz4 -O atime=off -O recordsize=128K \
  mirror wwn-X wwn-Y mirror wwn-Z wwn-N
```

## Containers

Install and run Docker:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt install -y containerd.io docker-ce docker-ce-cli docker-compose
systemctl enable --now docker
```

Create internal Docker networks:

```bash
docker network create proxy
docker network create nextcloud
```

### Traefik

```bash
touch /srv/home-server/apps/traefik2/acme.json
chmod 0600 /srv/home-server/apps/traefik2/acme.json
cd /srv/home-server/apps/traefik2 && docker-compose up -d
```

### Plex

First run only:
1. Get Plex claim code: https://www.plex.tv/claim
2. Update `plex/docker-compose` with claim code
