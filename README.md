Hayden's NixOS System Configurations
This repository contains the complete, declarative configuration for my ASUS ROG Zephyrus M16 (GU603ZW), managed with Nix Flakes.

💻 Machines
zephyrus-m16: ASUS ROG Zephyrus M16 (2022) GU603ZW

🚀 Automated Installation
This repository includes an automated script to perform a clean installation of NixOS.

Warning: This process will completely erase all data on the selected disk.

Pre-Installation Steps
Create a Bootable USB: Download the latest NixOS 25.05 GNOME ISO and flash it to a USB drive.

BIOS Settings: Boot from the USB drive. Enter the BIOS/UEFI setup and ensure:

Secure Boot is Disabled.

The system is in UEFI Mode.

Connect to the Internet: Once in the NixOS live environment, connect to your Wi-Fi or an Ethernet network.

Identify GPU Bus IDs (CRITICAL): This is the only manual step required. The script needs to know the exact hardware address of your Intel and NVIDIA GPUs.

Open a terminal and run:bash
lspci | grep -E "VGA|3D"

You will see output similar to this:

00:02.0 VGA compatible controller: Intel Corporation Alder Lake-P Integrated Graphics Controller (rev 0c)
01:00.0 VGA compatible controller: NVIDIA Corporation GA104M (rev a1)
Note the two numbers (e.g., 00:02.0 for Intel and 01:00.0 for NVIDIA).

You must now edit the modules/system/hardware/asus-zephyrus-m16.nix file in your GitHub repository and replace the placeholder intelBusId and nvidiaBusId values with the correct ones for your machine. The format is PCI:X:Y:Z. For example, 01:00.0 becomes "PCI:1:0:0".

Running the Install Script
Open a Terminal in the live environment.

Become root:

Bash

sudo -i
Run the Installer: Execute the following command to download and run the installation script directly from your repository. It will prompt you for one final confirmation before proceeding.

Bash

curl -sL [https://raw.githubusercontent.com/hbohlen/system-configs/main/install.sh](https://raw.githubusercontent.com/hbohlen/system-configs/main/install.sh) | bash
The script will handle partitioning, formatting, and installing your complete system. Once it's finished, the laptop will reboot into your new, fully configured NixOS installation.

🛠️ System Management
After installation, all system management is done through this Git repository.

To apply changes: After modifying any .nix file, navigate to your configuration directory (cd /etc/nixos or a local clone) and run:

Bash

sudo nixos-rebuild switch --flake.#zephyrus-m16
To update all packages: To update NixOS, your applications, and all dependencies to the latest versions, run:

Bash

nix flake update
Then, apply the updates with the nixos-rebuild switch command above.
