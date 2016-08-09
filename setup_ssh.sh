#!/bin/bash

# Setup client's public-key
mkdir -p ~/.ssh
# CLIENT_PUBKEY is set via resin.io env vars
for var in ${!CLIENT_PUBKEY@}; do
  echo "${!var}" | tee -a ~/.ssh/authorized_keys
done

SSH_HOST_KEYDIR="/data/ssh"
mkdir -p "${SSH_HOST_KEYDIR}"
KEYS=(dsa rsa ecdsa ed25519)
for key in "${KEYS[@]}"; do
  if [ ! -f "${SSH_HOST_KEYDIR}/ssh_host_${key}_key" ]; then
     echo Generating ${key} key...
     ssh-keygen -q -N '' -t ${key} -f "${SSH_HOST_KEYDIR}/ssh_host_${key}_key"
  fi
  ssh-keygen -l -f "${SSH_HOST_KEYDIR}/ssh_host_${key}_key"
done

service ssh start
