#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

### Checklist #################
# [x] Added to Containerfile  #
# [x] File is executable      #
#                             #
###############################

### Install Docker CE from Official Repository
echo "Installing Docker CE..."

# Add Docker RPM repository GPG key
rpm --import https://download.docker.com/linux/fedora/gpg

# Add Docker RPM repository
cat >/etc/yum.repos.d/docker.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://download.docker.com/linux/fedora/$releasever/source/stable
enabled=0
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg

[docker-ce-test]
name=Docker CE Test - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg

[docker-ce-test-source]
name=Docker CE Test - Sources
baseurl=https://download.docker.com/linux/fedora/$releasever/source/test
enabled=0
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

# Make sure there is a corresponding sysusers.d user before the install
<<EOT /usr/bin/sh
    set -xeuo pipefail
    cat > /usr/lib/sysusers.d/docker.conf << EOF
g docker -
EOF
EOT

# Install Docker CE
# shadow-utils, slirp4netns, iptables and iptables-nft are needed for Rootless Docker
dnf5 install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    shadow-utils \
    slirp4netns \
    iptables \
    iptables-nft

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/docker.repo

echo "Docker CE installed successfully"
echo "Docker CE installation complete!"
