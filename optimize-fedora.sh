#!/bin/bash
# Device-Specific Linux Optimization for Lenovo ThinkPad T490s
# OS: Fedora 44 (GNOME)

echo "Starting optimization for Fedora (ThinkPad T490s)..."

# 1. Update the system
echo "Updating system..."
sudo dnf update -y

# 2. Enable 100%+ volume over-amplification for GNOME
echo "Enabling volume over-amplification..."
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
echo "Over-amplification enabled."

# 3. Install OpenBangla Keyboard
echo "Installing OpenBangla Keyboard..."
sudo dnf copr enable badshah/openbangla-keyboard -y
sudo dnf install ibus-openbangla -y
echo "OpenBangla Keyboard installed. Please restart your session and add it in Keyboard Settings."

# Additional T490s specific tweaks (TLP for battery life)
echo "Installing TLP for battery optimization (resolving conflicts with default power daemons)..."
# Explicitly remove conflicting power daemons first
sudo dnf remove -y tuned-ppd power-profiles-daemon
sudo dnf install -y tlp tlp-rdw
sudo systemctl enable tlp
sudo systemctl start tlp

echo "Optimization complete!"
