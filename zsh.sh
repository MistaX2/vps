set -e

echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "Installing Zsh, Git, Curl, Wget..."
sudo apt install zsh git curl wget -y

# Ensure Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "Zsh installation failed. Exiting."
    exit 1
fi

echo "Installing Oh My Zsh (unattended)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export RUNZSH=no  # Prevent Oh My Zsh from trying to start Zsh immediately
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

echo "Setting Zsh as default shell..."
chsh -s $(which zsh)

echo "Installing plugins: zsh-autosuggestions and zsh-syntax-highlighting..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# Syntax Highlighting
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

echo "Configuring .zshrc..."
# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null || true

# Set theme and plugins
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc || echo 'ZSH_THEME="agnoster"' >> ~/.zshrc
sed -i 's/^plugins=.*/plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc || echo 'plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc

echo "Sourcing .zshrc..."
source ~/.zshrc || true

echo "✅ Oh My Zsh setup complete!"
echo "Close and reopen your terminal, or run 'zsh' to start using Zsh."
