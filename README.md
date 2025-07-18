# 🚧 UNDER DEVELOPMENT – KechiLab (v0.1)

**KechiLab** is a modular Wi-Fi security toolkit written entirely in Bash.  
It provides a command-line interface (CLI) to perform various wireless and network security operations with ease.

---

## 🔧 Features

- 📡 **Monitor Mode Management**  
  Enables or checks monitor mode for your wireless interface.

- 🔍 **Wi-Fi Scanning**  
  Lists nearby Wi-Fi networks and connected clients using `airodump-ng`.

- 💣 **Deauthentication Attack**  
  Disconnects clients from a selected network using `aireplay-ng`.

- 🌐 **Port Scanning**  
  Quickly finds live hosts with `masscan`, then scans open ports with `nmap`.

- 🖥️ **Interactive CLI Menu**  
  Easy-to-use text-based interface to run all modules from a single script.

---

## ⚙️ Requirements

You need a Linux system (Kali, Parrot OS, Ubuntu, etc.) with the following tools installed:

- `aircrack-ng` (for `airodump-ng`, `aireplay-ng`)
- `masscan`
- `nmap`
- `bash` (default in most systems)

Install them via APT:

```bash
sudo apt update && sudo apt install aircrack-ng masscan nmap -y
```

---

## 🚀 Usage

Make the main script executable:

```bash
chmod +x KechiLab.sh
sudo ./KechiLab.sh
```

Select any module from the menu and follow the on-screen instructions.

---

## 📁 Modules Overview

| Script Name        | Description                               |
| ------------------ | ----------------------------------------- |
| `KechiLab.sh`      | Main menu interface, runs all modules     |
| `monitor_check.sh` | Enables or checks monitor mode            |
| `scan.sh`          | Scans for Wi-Fi networks and clients      |
| `deauth.sh`        | Performs deauth attack on selected client |
| `portscan.sh`      | Scans IP/subnet with masscan and nmap     |

---

## 🧪 Status

This project is **actively under development**.
More features and modules will be added soon, including:

* 📁 Log saving & session reports
* 📡 Rogue AP / Evil Twin modules
* 🧠 Targeted wordlist generator
* 🧪 Better error handling and input validation

---

## 🛡️ Disclaimer

> ⚠️ This tool is intended for **educational and authorized testing purposes only**.
> Unauthorized use against networks or devices you don't own is **illegal**.

---

## 🤖 Author

**KechiZona**  
GitHub: [@KechiZona](https://github.com/KechiZona)

---

Feel free to fork, suggest features, or contribute!
