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

if [ "$PLATFORM" = "Termux" ] || [ "$PLATFORM" = "WSL" ]; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
fi

if [ "$PLATFORM" = "Termux" ] || [ "$PLATFORM" = "WSL" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
elif [ "$PLATFORM" = "PowerShell" ]; then
  winget install JanDeDobbeleer.OhMyPosh
  echo 'oh-my-posh init pwsh | Invoke-Expression' >> $PROFILE
fi

if [ "$PLATFORM" = "Termux" ]; then
  mkdir -p ~/.termux
  wget -O ~/.termux/font.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  termux-reload-settings
elif [ "$PLATFORM" = "WSL" ] || [ "$PLATFORM" = "PowerShell" ]; then
  echo "Please install the Meslo Nerd Font manually from here: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
fi

if [ "$PLATFORM" = "Termux" ] || [ "$PLATFORM" = "WSL" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ "$PLATFORM" = "Termux" ] || [ "$PLATFORM" = "WSL" ]; then
  sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
  sed -i 's/^plugins=(.*)/plugins=(git zoxide zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
  echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
fi
