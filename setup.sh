#!/bin/bash

if [ -n "$TERMUX_VERSION" ]; then # More robust Termux detection using a Termux-specific env var
  PLATFORM="Termux"
elif uname -r | grep -q "microsoft"; then # Check kernel for microsoft (for WSL)
  PLATFORM="WSL"
elif [ -n "$WSL_DISTRO_NAME" ]; then # Check for WSL specific environment variable
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
fi

if [ "$PLATFORM" = "Termux" ]; then
  mkdir -p ~/.termux
  wget -O ~/.termux/font.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  termux-reload-settings
elif [ "$PLATFORM" = "WSL" ]; then # Removed PowerShell specific instruction for font
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

# --- DOTFILES DEPLOYMENT ---
echo "Deploying dotfiles..."

DOTFILES_DIR="$(dirname "$(realpath "$0")")/dotfiles" # Get absolute path to dotfiles in the repo

if [ -d "$DOTFILES_DIR" ]; then
  # Create ~/.config directory if it doesn't exist
  mkdir -p "$HOME/.config"

  # Find all dotfiles (files starting with .) and config files
  find "$DOTFILES_DIR" -type f -print0 | while IFS= read -r -d $'\0' dotfile; do
    relative_path="${dotfile#$DOTFILES_DIR/}" # Remove DOTFILES_DIR prefix

    # Construct target path in home directory
    target_path="$HOME/${relative_path}"

    # Ensure parent directory exists for the target file
    mkdir -p "$(dirname "$target_path")"

    # Backup existing dotfile if it's not a symlink to our repo
    if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
      echo "Backing up existing $target_path to $target_path.bak"
      mv "$target_path" "$target_path.bak"
    elif [ -L "$target_path" ] && [ "$(readlink "$target_path")" != "$dotfile" ]; then
      echo "Existing symlink $target_path points elsewhere. Backing it up to $target_path.bak"
      mv "$target_path" "$target_path.bak"
    fi

    echo "Creating symlink: $dotfile -> $target_path"
    ln -sf "$dotfile" "$target_path" # -s for symbolic, -f for force (overwrite existing)
  done

  echo "Dotfiles deployed successfully."
  echo "NOTE: Remember to create a '~/.private_vars' file for sensitive environment variables (e.g., API keys)."
  echo "Add 'export GEMINI_API_KEY=\"YOUR_ACTUAL_GEMINI_API_KEY\"' and 'export GITHUB_TOKEN=\"YOUR_ACTUAL_GITHUB_TOKEN\"' to it."
else
  echo "Dotfiles directory not found at $DOTFILES_DIR. Skipping dotfiles deployment."
fi

# Install Gemini CLI (for all platforms where npm is available)
echo "Installing Gemini CLI..."
if command -v npm &> /dev/null
then
    npm install -g @google/gemini-cli
    echo "Gemini CLI installed successfully."
else
    echo "npm not found. Skipping Gemini CLI installation."
fi
