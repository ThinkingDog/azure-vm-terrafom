#!/bin/bash

set -e -u -o pipefail

echo "[$(date +"%FT%T")]  Adding az cli packages"
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
gpg --dearmor | \
sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list

echo "[$(date +"%FT%T")]  Updating apt-get and installing apache and az clie"
apt-get -y update
apt-get install -y jq azure-cli apache2
