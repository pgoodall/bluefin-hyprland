#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

###############################################################################
# Installing 1Password from Official Repositories
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

### Install 1Password from Official Repository
echo "Installing 1Password..."

# Add the 1Password repo key
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Add 1Password repository
cat >/etc/yum.repos.d/1password.repo <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey="https://downloads.1password.com/linux/keys/1password.asc"
EOF

# Make /opt an overlayfs
systemctl enable --now ostree-state-overlay@opt.service

# Install 1Password
dnf5 install -y 1password

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/1password.repo

echo "1Password installed successfully"

echo "1Password installation complete!"
