#!/bin/bash

iface=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)

if iwconfig "$iface" 2>/dev/null | grep -q "Mode:Monitor"; then
    echo "[✓] $iface is already in monitor mode."
    exit 0
fi

echo "[*] Enabling monitor mode on interface: $iface..."
airmon-ng start "$iface"


new_iface=$(iw dev | awk '$1=="Interface"{print $2}' | grep mon | head -n1)
[ -z "$new_iface" ] && new_iface="$iface"

if iwconfig "$new_iface" 2>/dev/null | grep -q "Mode:Monitor"; then
    echo "[✓] Monitor mode enabled: $new_iface"
else
    echo "[!] Monitor mode activation failed: verification failed."
    exit 1
fi