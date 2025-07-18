#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run this script as root."
  exit 1
fi

# 🎯 IP al
if [ -n "$1" ]; then
  target="$1"
else
  local_ip=$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  if [ -z "$local_ip" ]; then
    echo "[!] Aktif bir IP adresi bulunamadı (wlan0)."
    exit 1
  fi
  
  subnet=$(echo "$local_ip" | awk -F. '{print $1"."$2"."$3".0/24"}')
  echo "[*] Scanning live hosts in subnet: $subnet"
  nmap -sn "$subnet"
  read -p "Enter target IP or subnet (e.g. 192.168.1.1): " target
fi


rm -f ports.masscan nmap_result.txt


echo "[*] Scanning all ports with masscan..."
masscan -p0-65535 "$target" --rate=10000 -oG ports.masscan 


ports=$(grep "Ports:" ports.masscan | grep "open" | awk -F 'Ports: ' '{print $2}' | awk -F '/' '{print $1}' | paste -sd, -)

if [ -z "$ports" ]; then
  echo "[!] No open ports found. Check target or network."
  cat ports.masscan
  exit 1
fi

echo "[+] Open ports found: $ports"


echo "[*] Running nmap..."
nmap -sS -sV -Pn -p "$ports" "$target" -oN nmap_result.txt

echo "[✓] Scan complete. Results saved to: nmap_result.txt"
cat nmap_result.txt
