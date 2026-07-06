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
echo "Essential preparation for installing 1Password..."

1PASSWORD_DIR="/ctx/custom/files/1Password"

# Make sure there is a corresponding sysusers.d user before the install
<<EOT /usr/bin/sh
    set -xeuo pipefail
    cat > /usr/lib/sysusers.d/1password.conf << EOF
g onepassword -
g onepassword-cli -
g onepassword-mcp -
EOF
EOT

# Install 1Password policy file for system unlock
install -Dm0644 ${1PASSWORD_DIR}/com.1password.1Password.policy -t /usr/share/polkit-1/actions/

GROUP_NAME="onepassword"

# Setup the Core App Integration helper binary with the correct permissions and group
if [ ! "$(getent group "${GROUP_NAME}")" ]; then
    groupadd "${GROUP_NAME}"
fi

MCP_GROUP_NAME="onepassword-mcp"

# Setup the MCP server binary with its own group and setgid so OPH can verify
# connecting peers via SO_PEERCRED.
if [ ! "$(getent group "${MCP_GROUP_NAME}")" ]; then
    groupadd "${MCP_GROUP_NAME}"
fi

# Add .desktop file and icons for .tar.gz installs
echo "Adding 1Password .desktop file ..."
if [ -d /usr/share/applications ]; then
    # xdg-desktop-menu will only be available if xdg-utils is installed, which is likely but not guaranteed
    if [ -n "$(which xdg-desktop-menu)" ]; then
        xdg-desktop-menu install --mode system --novendor ${1PASSWORD_DIR}/1password.desktop
    else
        install -m0644 ${1PASSWORD_DIR}/1password.desktop /usr/share/applications
    fi
fi

echo "Copying over the 1Password icons..."
if [ -d /usr/share/icons ]; then
    cp -rf ${1PASSWORD_DIR}/icons/* /usr/share/icons/
    # Update theme mtime to indicate update
    touch /usr/share/icons/hicolor
fi

# Register path symlink even if it doesn't exist yet
ln -sf /opt/1Password/1password /usr/bin/1password

echo "1Password prep complete!"
