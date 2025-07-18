#!/bin/bash

main_menu() {
  clear
  echo "====== KechiLab CLI ======"
  echo "1) Port Scan"
  echo "2) WiFi Deauth Attack"
  echo "3) Monitor Mode Kontrol"
  echo "0) Çıkış"
  echo "=========================="
  read -p "Seçiminiz: " choice
  echo "[!] Warning: 'airmon-ng check kill' will stop some network services."
  echo "    This might disconnect you from Wi-Fi temporarily."
  echo ""
  echo "[*] To restore your connection after scanning:"
  echo "    1. Restart NetworkManager:"
  echo "       sudo systemctl restart NetworkManager"
  echo "    2. Reconnect to your Wi-Fi network manually."

  case $choice in
    1)
      bash modules/portscan.sh
      echo -e "\n--- Sonuç ---"
      cat nmap_result.txt 
      ;;
    2)
      bash modules/deauth.sh
      echo -e "\n--- Sonuç ---"
      echo "Deauth attack tamamlandı (ayrıntılı çıktı yukarıda)."
      ;;
    3)
      bash modules/monitor_check.sh
      echo -e "\n--- Sonuç ---"
      echo "Monitor mode kontrolü tamamlandı."
      ;;
    0)
      echo "Çıkılıyor..."
      exit 0
      ;;
    *)
      echo "Geçersiz seçim!"
      sleep 1
      ;;
  esac
}

while true; do
  main_menu
  read -p "Devam etmek için Enter'a basın..."
done