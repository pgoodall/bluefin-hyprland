#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

###############################################################################
# Example: Installing Doker CE and Google Chrome from Official Repositories
###############################################################################
# This is an EXAMPLE file showing how to add third-party RPM repositories
# and install packages from them following Universal Blue/Bluefin conventions.
#
# To use this script:
# 1. Rename this file to remove the .example extension: 20-onepassword.sh
# 2. The build system will automatically run scripts in numerical order
#
# IMPORTANT CONVENTIONS (from @ublue-os/bluefin):
# - Always clean up temporary repository files after installation
# - Use dnf5 exclusively (never dnf or yum)
# - Always use -y flag for non-interactive operations
# - Remove repo files to keep the image clean (repos don't work at runtime)
###############################################################################

### Install Google Chrome from Official Repository
echo "Skipping install for Google Chrome..."

# Add Google Chrome RPM repository
# cat >/etc/yum.repos.d/google-chrome.repo <<'EOF'
# [google-chrome]
# name=google-chrome
# baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
# enabled=1
# gpgcheck=1
# gpgkey=https://dl.google.com/linux/linux_signing_key.pub
# EOF

### This fails when trying to write to /opt. 
# Install Chrome
# dnf5 install -y google-chrome-stable

# Clean up repo file (required - repos don't work at runtime in bootc images)
# rm -f /etc/yum.repos.d/google-chrome.repo

# echo "Google Chrome installed successfully"

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

# Install Docker CE
dnf5 install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/docker.repo

echo "Docker CE installed successfully"
echo "Chrome and Docker installation complete!"
