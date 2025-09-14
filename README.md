# Hayden's System Configurations

This repository contains the NixOS configuration for my machines, managed with Nix Flakes.

## 💻 Machines

- **zephyrus**: ASUS ROG Zephyrus M16 (GU603ZW)

## 🚀 First-Time Installation

**Warning:** This process will erase all data on the target disk.

1.  Boot the NixOS 25.05 installer from a USB drive.
2.  Connect to the internet (Wi-Fi or Ethernet).
3.  Clone this repository:
    ```bash
    git clone [https://github.com/hbohlen/system-configs.git](https://github.com/hbohlen/system-configs.git)
    cd system-configs
    ```
4.  **CRITICAL:** Verify your disk name with `lsblk`. Open the installation script at `scripts/install-asus-zephyrus-m16.sh` and ensure the `DISK` variable is correct (e.g., `/dev/nvme0n1`).
5.  Make the script executable and run it:
    ```bash
    chmod +x scripts/install-asus-zephyrus-m16.sh
    sudo ./scripts/install-asus-zephyrus-m16.sh
    ```
The script will partition the drive, format it, and install the NixOS configuration from this repository.

## 🛠️ Post-Installation Management

To apply changes after modifying the configuration files:

1.  Navigate to your configuration directory:
    ```bash
    cd ~/system-configs
    ```
2.  Rebuild the system using the alias defined in your `home.nix`:
    ```bash
    update
    ```

### Advanced Features

- **Secrets Management (`agenix`)**: This setup uses `agenix` to manage secrets like user passwords. To edit secrets:
    1.  Install `agenix`: `nix-shell -p agenix`
    2.  Edit the secrets file: `agenix -e secrets/secrets.yaml`
    3.  After saving, the file will be re-encrypted. Commit the changes.
- **Custom Packages (`overlays`)**: You can add or modify packages in the `overlays/default.nix` file. This is the standard way to customize your package set.
