#!/bin/bash


rm -f networks-01.csv

echo "[*] Monitor mode kontrol ediliyor..."
./monitor_check.sh


mon_interface=$(iw dev | awk '$1=="Interface"{print $2}' | grep mon | head -n1)
if [ -z "$mon_interface" ]; then
  echo "[!] Monitor interface bulunamadı."
  exit 1
fi

echo "[*] Ağlar ve istemciler taranıyor. Ağları ve cihazları görmek için 10-20 saniye bekleyip CTRL+C ile durdurun."
sleep 2
airodump-ng -w networks --output-format csv "$mon_interface"

if [ ! -f networks-01.csv ]; then
  echo "[!] networks-01.csv bulunamadı."
  exit 1
fi
clear
echo ""
echo "============================ Bulunan Ağlar ============================"
printf "%-3s | %-25s | %-17s | %-5s | %-10s\n" "No" "SSID" "BSSID" "Kanal" "Şifre"
echo "-----------------------------------------------------------------------"
awk -F',' '
/^BSSID/ {p=1; n=1; next}
/^Station MAC/ {p=0}
p && $1!="" {
    printf "%-3d | %-25s | %-17s | %-5s | %-10s\n", n++, $14, $1, $4, $6
}' networks-01.csv

echo ""
echo "============= Ağlara Bağlı Cihazlar ==============="
printf "%-3s | %-17s | %-17s\n" "No" "Cihaz MAC" "Bağlı Olduğu BSSID"
echo "---------------------------------------------------"
awk -F',' '
/^Station MAC/ {p=1; n=1; next}
p && $1!="" {
    printf "%-3d | %-17s | %-17s\n", n++, $1, $6
}' networks-01.csv