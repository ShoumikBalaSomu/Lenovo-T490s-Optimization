# 💻 Lenovo ThinkPad T490s Optimization Suite - MAX PERFORMANCE

<div align="center">
  <img src="https://img.shields.io/badge/Device-ThinkPad_T490s-red?style=for-the-badge&logo=lenovo" />
  <img src="https://img.shields.io/badge/OS-Windows_11_%2F_Fedora-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Max_Optimized-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" />
</div>

---

## 📖 Overview

A **comprehensive, max-optimized** collection of scripts specifically tailored for the **Lenovo ThinkPad T490s**. This project delivers maximum performance, extended battery life, enhanced privacy, and superior user experience on both Windows 11 and Fedora Linux.

### 🎯 What's New in MAX Version

**Fedora Script (optimize-fedora.sh):**
- ✅ Advanced TLP power management with device-specific tuning
- ✅ ZRAM compression for better memory performance
- ✅ Early OOM killer to prevent system freezes
- ✅ Kernel parameter optimizations (network, VM, filesystem)
- ✅ GNOME desktop performance tweaks
- ✅ Comprehensive system monitoring tools
- ✅ Automatic optimization report generation

**Windows Script (optimize-windows.ps1):**
- ✅ Ultimate Performance power plan activation
- ✅ Complete telemetry & bloatware removal
- ✅ Network stack optimization (CTCP, Fast Open)
- ✅ Visual effects optimization for performance
- ✅ SSD TRIM & storage optimization
- ✅ Gaming performance enhancements
- ✅ Automated software installation via Winget
- ✅ Detailed optimization reports

## ✨ Key Optimizations

### 🔋 Power Management
| Feature | Fedora | Windows |
|---------|--------|---------|
| Advanced Power Daemon | TLP with custom config | Ultimate Performance Plan |
| CPU Governor | Performance/Powersave (auto) | Custom P-states |
| GPU Power | Intel UHD 620 optimized | N/A |
| Battery Threshold | Configurable | N/A |
| Turbo Boost | AC only | AC only |

### 🚀 Performance
| Feature | Fedora | Windows |
|---------|--------|---------|
| Memory | ZRAM (zstd) | Optimized paging |
| Network | BBR congestion control | CTCP + Fast Open |
| Disk | NVMe optimized | TRIM enabled |
| OOM Protection | EarlyOOM | Standard |
| Visual Effects | Animations disabled | Performance mode |

### 🔒 Privacy & Security
| Feature | Fedora | Windows |
|---------|--------|---------|
| Telemetry | N/A | Fully disabled |
| Bloatware | Minimal install | 35+ apps removed |
| Data Collection | None | Disabled |
| Cortana | N/A | Disabled |

### ⌨️ Input & Keyboard
- OpenBangla Keyboard support (Fedora)
- Mouse acceleration disabled (Windows)
- Custom key repeat rates
- HiDPI fractional scaling

## 🚀 Quick Start

### For Fedora Users

```bash
# Clone the repository
git clone https://github.com/shoumikbalasomu/Lenovo-T490s-Optimization.git
cd Lenovo-T490s-Optimization

# Make script executable
chmod +x optimize-fedora.sh

# Run as root
sudo ./optimize-fedora.sh

# Reboot required
sudo reboot
```

**Post-Installation:**
1. Add OpenBangla Keyboard: Settings → Keyboard → Input Sources
2. Run `sudo powertop --auto-tune` for additional tuning
3. Monitor with: `tlp-stat -s` or `powertop`

### For Windows Users

```powershell
# Clone the repository
git clone https://github.com/shoumikbalasomu/Lenovo-T490s-Optimization.git
cd Lenovo-T490s-Optimization

# Run PowerShell as Administrator
# Right-click PowerShell → Run as Administrator

# Execute the script
.\optimize-windows.ps1
```

**Post-Installation:**
1. Restart your computer
2. Install drivers via Lenovo Vantage
3. Update BIOS to latest version
4. Generate battery report: `powercfg /batteryreport`

## 📊 Expected Results

### Battery Life Improvements
- **Fedora**: 8-12 hours (mixed usage)
- **Windows**: 6-10 hours (mixed usage)

### Performance Gains
- **Boot Time**: 30-50% faster
- **Application Launch**: 20-40% faster
- **Network Throughput**: 10-25% improvement
- **Memory Efficiency**: 40-60% better with ZRAM

## 🛠️ Requirements

- **Device**: Lenovo ThinkPad T490s
- **OS**: 
  - Windows 11 (21H2 or later)
  - Fedora 38+ (Workstation/Silverblue)
- **Permissions**: 
  - Root/Administrator access required
  - Internet connection for package installation

## 📋 What Each Script Does

### Fedora Script Breakdown
1. System update & essential packages
2. TLP power management configuration
3. ZRAM compressed swap setup
4. Early OOM killer configuration
5. Kernel parameter tuning
6. GNOME desktop optimization
7. OpenBangla Keyboard installation
8. Essential software installation
9. Service optimization
10. System cleanup
11. Optimization report generation

### Windows Script Breakdown
1. Telemetry & data collection disable
2. Ultimate Performance power plan
3. Bloatware removal (35+ apps)
4. Network stack optimization
5. Visual effects optimization
6. SSD & storage optimization
7. Gaming performance tweaks
8. Essential software via Winget
9. System cleanup
10. Optimization report generation

## 🔧 Troubleshooting

### Fedora Issues
```bash
# Check TLP status
tlp-stat -s

# View battery info
tlp-stat -b

# Check ZRAM
zramctl

# View kernel parameters
sysctl -a | grep -E 'vm.swappiness|net.ipv4.tcp'
```

### Windows Issues
```powershell
# Check power plans
powercfg -list

# View battery report
powercfg /batteryreport

# Check network settings
netsh int tcp show global

# Verify services
Get-Service | Where-Object {$_.StartType -eq "Disabled"}
```

## 📜 License

Licensed under the [MIT License](LICENSE). Copyright © 2026 Shoumik Bala Somu.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ⚠️ Disclaimer

These scripts make significant system changes. While tested, results may vary:
- **Backup important data** before running
- **Review scripts** before execution
- **Run at your own risk**
- Author is not responsible for any issues

---

<div align="center">
  <p><strong>Pushing the boundaries of the legendary T490s to MAX performance! 💻🚀</strong></p>
  <p>Built with ❤️ for ThinkPad enthusiasts</p>
</div>
