#!/bin/bash
# Device-Specific Linux Optimization for Lenovo ThinkPad T490s
# OS: Fedora 44 (GNOME)
# Optimized for: Performance, Battery Life, Privacy, and User Experience

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "========================================"
echo "  Fedora Optimization for T490s"
echo "  Max Performance & Battery Edition"
echo "========================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   log_error "This script must be run as root (use sudo)"
   exit 1
fi

# 1. System Update & Essential Packages
log_info "Updating system packages..."
dnf update -y --refresh
dnf upgrade -y
log_success "System updated"

# Install essential optimization tools
log_info "Installing essential optimization tools..."
dnf install -y \
    tlp tlp-rdw \
    powertop \
    thermald \
    irqbalance \
    earlyoom \
    preload \
    zram-generator-defaults \
    gnome-tweaks \
    dnf-plugins-core \
    fastfetch \
    htop \
    btop \
    nvme-cli \
    smartmontools

# 2. Enable TLP for Advanced Power Management
log_info "Configuring TLP for maximum battery efficiency..."
# Remove conflicting power daemons
dnf remove -y tuned-ppd power-profiles-daemon 2>/dev/null || true

# Enable and start TLP
systemctl enable tlp
systemctl start tlp
systemctl enable tlp-sleep
systemctl start tlp-sleep

# Configure TLP for T490s (Intel CPU + SSD)
cat > /etc/tlp.conf << 'EOF'
# TLP Configuration for Lenovo ThinkPad T490s
# Optimized for Battery Life & Performance

# Processor Performance
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=powersave
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=80

# Intel P-State Turbo Boost
TURBO_BOOST_ON_AC=1
TURBO_BOOST_ON_BAT=0

# Graphics (Intel UHD 620)
INTEL_GPU_MIN_FREQ_ON_AC=300
INTEL_GPU_MAX_FREQ_ON_AC=1150
INTEL_GPU_MIN_FREQ_ON_BAT=300
INTEL_GPU_MAX_FREQ_ON_BAT=800

# PCI Express Active State Power Management
PCIE_ASPM_ON_AC=default
PCIE_ASPM_ON_BAT=powersupersave

# SATA Link Power Management
SATA_LINKPWR_ON_AC=max_performance
SATA_LINKPWR_ON_BAT=min_power

# USB Autosuspend
USB_AUTOSUSPEND=1
USB_BLACKLIST="^(04ca|06cb|046d|0bda|8087)"

# WiFi Power Saving
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Sound Power Saving
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1
SOUND_POWER_SAVE_CONTROLLER=1

# Runtime PM for PCIe devices
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto

# Disk Spindown (for HDD, NVMe ignores this)
DISK_IDLE_SECS_ON_AC=0
DISK_IDLE_SECS_ON_BAT=2

# NMI Watchdog
NMI_WATCHDOG=0

# Dirty Pages Writeback
VM_DIRTIFY_RATIO=10
VM_DIRTIFY_BACKGROUND_RATIO=5
VM_WRITEBACK_RATIO=10

# Laptop Mode (write caching)
LM_BATTERY_THRESHOLD=20
EOF

log_success "TLP configured for T490s"

# 3. Enable ZRAM for Better Memory Management
log_info "Configuring ZRAM for improved memory performance..."
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram, 8192)
compression-algorithm = zstd
EOF

# Reload systemd and restart zram
systemctl daemon-reload
systemctl restart systemd-zram-setup@zram0.service 2>/dev/null || true
log_success "ZRAM configured"

# 4. Enable Early OOM Killer (Prevent System Freezes)
log_info "Configuring early OOM killer..."
systemctl enable earlyoom
systemctl start earlyoom

cat > /etc/default/earlyoom << 'EOF'
EARLYOOM_ARGS="-r 4,2 -s 2,1"
EOF

systemctl restart earlyoom
log_success "Early OOM configured"

# 5. Optimize Kernel Parameters
log_info "Applying kernel parameter optimizations..."
cat > /etc/sysctl.d/99-t490s-optimization.conf << 'EOF'
# Improve VM performance
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=500

# Network optimizations
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 65536 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_congestion_control=bbr
net.core.default_qdisc=fq
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0

# File system optimizations
fs.file-max=2097152
fs.inotify.max_user_watches=524288

# Reduce swap usage
vm.min_free_kbytes=65536
EOF

sysctl --system >/dev/null 2>&1
log_success "Kernel parameters optimized"

# 6. GNOME Desktop Optimizations
log_info "Optimizing GNOME desktop environment..."

# Enable volume over-amplification
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true 2>/dev/null || true

# Disable animations for better performance
gsettings set org.gnome.desktop.interface enable-animations false 2>/dev/null || true

# Set faster key repeat rate
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.keyboard delay 200 2>/dev/null || true

# Enable fractional scaling (for HiDPI displays)
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" 2>/dev/null || true

# Disable unnecessary GNOME extensions
gsettings set org.gnome.shell disable-user-extensions false 2>/dev/null || true

# Optimize power settings in GNOME
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend' 2>/dev/null || true

log_success "GNOME optimized"

# 7. Install OpenBangla Keyboard
log_info "Installing OpenBangla Keyboard..."
if ! dnf repo list | grep -q openbangla; then
    dnf copr enable badshah/openbangla-keyboard -y
fi
dnf install -y ibus-openbangla
log_success "OpenBangla Keyboard installed"

# 8. Install Additional Useful Software
log_info "Installing additional useful applications..."
dnf install -y \
    ffmpeg \
    vlc \
    gimp \
    libreoffice \
    firefox \
    git \
    vim \
    neovim \
    curl \
    wget \
    unzip \
    p7zip \
    timeshift \
    flatpak \
    gnome-software-plugin-flatpak

# Enable Flatpak and install runtime
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
log_success "Additional software installed"

# 9. Enable Necessary Services
log_info "Enabling system services..."
systemctl enable irqbalance
systemctl start irqbalance
systemctl enable thermald
systemctl start thermald
systemctl enable preload
systemctl start preload
log_success "Services enabled"

# 10. Clean Up System
log_info "Cleaning up system..."
dnf autoremove -y
dnf clean all
rm -rf /var/cache/dnf/*
log_success "System cleaned"

# 11. Create Optimization Report
log_info "Generating optimization report..."
cat > /tmp/t490s-optimization-report.txt << EOF
=== T490s Fedora Optimization Report ===
Date: $(date)
Hostname: $(hostname)
Kernel: $(uname -r)

== Installed Optimization Tools ==
$(rpm -qa | grep -E 'tlp|powertop|thermald|earlyoom|preload' | sort)

== TLP Status ==
$(systemctl status tlp --no-pager | head -10)

== ZRAM Status ==
$(zramctl 2>/dev/null || echo "ZRAM not available")

== Current Governor ==
$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | head -1)

== Power Profile ==
$(powerprofilesctl get 2>/dev/null || echo "Power profiles daemon removed, using TLP")
EOF

echo ""
echo "========================================"
log_success "Optimization Complete!"
echo "========================================"
echo ""
echo "📊 Optimization Report saved to: /tmp/t490s-optimization-report.txt"
echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "  1. Reboot your system for changes to take effect"
echo "  2. Add OpenBangla Keyboard in Settings > Keyboard > Input Sources"
echo "  3. Run 'sudo powertop --auto-tune' after reboot for additional tuning"
echo "  4. Monitor battery with 'tlp-stat -b' and 'powertop'"
echo ""
echo "🔧 Useful Commands:"
echo "  - Check TLP status: tlp-stat -s"
echo "  - Battery info: tlp-stat -b"
echo "  - Power consumption: powertop"
echo "  - CPU frequency: cpupower frequency-info"
echo ""
echo "Enjoy your optimized ThinkPad T490s! 🚀"
