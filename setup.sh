#!/bin/bash

if [ -d "/data/data/com.termux" ]; then
  PLATFORM="Termux"
elif [ -n "$PSVersionTable" ]; then
  PLATFORM="PowerShell"
elif grep -q "Microsoft" /proc/version; then
  PLATFORM="WSL"
else
  PLATFORM="Unknown"
fi

echo "Detected platform: $PLATFORM"

if [ "$PLATFORM" = "Termux" ]; then
  pkg update && pkg upgrade -y
elif [ "$PLATFORM" = "WSL" ]; then
  sudo apt update && sudo apt upgrade -y
elif [ "$PLATFORM" = "PowerShell" ]; then
  winget upgrade --all
fi
