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