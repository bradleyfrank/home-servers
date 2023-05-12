#!/usr/bin/env bash

set -eo pipefail

[[ -z $1 ]] && exit 1

cd "$(git rev-parse --show-toplevel)" || exit 1

if multipass list --format json | jq -r '.list[]|.name' | grep -E "^${1}$" &> /dev/null; then
  multipass delete --purge "$1"
fi

multipass launch -c 2 -m 4G -d 16G -n "$1"
multipass transfer scripts/bootstrap.sh "$1":/tmp
multipass exec "$1" -- sudo bash /tmp/bootstrap.sh

ip="$(multipass list --format json | jq -r --arg n "$1" '.list[]|select(.name == $n).ipv4[0]')"

printf "%s ansible_host=%s\n\n[app]\n%s\n\n[zfs]\n%s" "$1" "$ip" "$1" "$1" > inventory-dev.ini

