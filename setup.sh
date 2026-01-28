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
  pkg install git curl wget tar zip unzip python nodejs-lts termux-api -y
elif [ "$PLATFORM" = "WSL" ]; then
  sudo apt update && sudo apt upgrade -y
  sudo apt install git curl wget tar zip unzip python3 nodejs npm -y
elif [ "$PLATFORM" = "PowerShell" ]; then
  winget upgrade --all
  choco install git curl wget tar zip unzip python nodejs-lts -y
fi

if [ "$PLATFORM" = "Termux" ]; then
  pkg install zsh zoxide -y
elif [ "$PLATFORM" = "WSL" ]; then
  sudo apt install zsh zoxide -y
fi

if [ "$PLATFORM" = "Termux" ] || [ "$PLATFORM" = "WSL" ]; then
  chsh -s zsh
fi