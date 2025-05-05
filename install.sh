#!/bin/bash

echo "Starting installation..."

# Update & upgrade
sudo apt update && sudo apt upgrade -y

# 1. Install Java JDK
echo "Installing Java JDK..."
sudo apt install default-jdk -y

# 2. Install Android SDK
echo "Installing Android SDK..."
sudo apt install android-sdk -y

# 3. Install SDK Manager (verify with list)
sdkmanager --list

# 4. Install Flask and virtual environment
echo "Installing Flask and setting up virtual environment..."
sudo apt install python3-venv -y
python3 -m venv flask-env
source flask-env/bin/activate
pip install flask
pip show flask
deactivate

# 5. Install Ngrok
echo "Installing Ngrok..."
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin

# 6. Install Wireshark
echo "Installing Wireshark..."
sudo apt install wireshark -y

# 7. Install MobSF
echo "Installing MobSF..."
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF
./setup.sh || echo "Setup failed, trying Python 3.11 workaround..."

# Python 3.11 workaround for MobSF
cd ~
sudo apt install python3.11 python3.11-venv python3.11-dev -y || (
    echo "Installing Python 3.11 manually..."
    sudo apt install -y wget build-essential libssl-dev zlib1g-dev \
    libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev \
    libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev
    cd /tmp
    wget https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tgz
    tar -xvf Python-3.11.8.tgz
    cd Python-3.11.8
    ./configure --enable-optimizations
    make -j$(nproc)
    sudo make altinstall
)

cd ~/Mobile-Security-Framework-MobSF
python3.11 -m venv venv
source venv/bin/activate
./setup.sh
pip install --upgrade pip
pip install six

# wkhtmltopdf dependency
echo "Installing wkhtmltopdf dependencies..."
echo "deb http://security.debian.org/debian-security bullseye-security main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install libssl1.1 -y

# Install wkhtmltopdf manually
echo "Please manually download wkhtmltopdf .deb from: https://wkhtmltopdf.org/downloads.html"
echo "Then run: sudo dpkg -i wkhtmltox_0.12.6.1-2.bullseye_amd64.deb"

# Final info
echo "All tools installed. You can now open Android Studio to build your RAT project."

exit 0
