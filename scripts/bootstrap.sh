#!/usr/bin/env bash

set -eo pipefail

useradd --create-home --user-group --shell /bin/bash --comment "Ansible user" deploy > /dev/null
mkdir /home/deploy/.ssh > /dev/null && chmod 0700 /home/deploy/.ssh
cat << 'EOF' > /home/deploy/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXi9rxK1HI1v2QOrjupf6XM9evD2vKfw3msmUbWlb7n ansible@francopuccini.casa
EOF
chown -R deploy:deploy /home/deploy/.ssh
cat << EOF > /etc/sudoers.d/deploy
deploy ALL=NOPASSWD: ALL
EOF

