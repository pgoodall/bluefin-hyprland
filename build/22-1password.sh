#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

###############################################################################
# Installing Visual Studio Code from Official Repositories
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

### Install Visual Studio Code from Official Repository
echo "Installing Visual Studio Code..."

# Add Visual Studio Code RPM repository
cat >/etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Install Visual Studio Code
dnf5 install -y code

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/vscode.repo

echo "Visual Studio Code installed successfully"

echo "Visual Studio Code installation complete!"
