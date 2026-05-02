#!/bin/bash
echo "=== ChimeraX OS Post-Install ==="

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Super><Shift>space']"

mkdir -p /etc/chimerax/core
chmod 700 /etc/chimerax
cp /boot/chimerax/linkernel.dat.png /etc/chimerax/core/.linkernel.dat.png
chmod 600 /etc/chimerax/core/.linkernel.dat.png

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.usebottles.bottles
flatpak install -y flathub cc.arduino.arduinoide

curl -# --proto '=https' --tlsv1.2 -Sf https://repo.waydro.id/waydroid.gpg > /usr/share/keyrings/waydroid.gpg
echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id $(lsb_release -sc) main" > /etc/apt/sources.list.d/waydroid.list
apt update
apt install -y waydroid

wget -q -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb
apt install -f -y
rm discord.deb

wget -qO - https://apt.packages.shiftkey.dev/gpg.key | apt-key add -
echo "deb [arch=amd64] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list
apt update
apt install -y github-desktop

apt install -y steam lutris code qemu-system-x86 utm

curl -fsSL https://ollama.com/install.sh | sh
ollama pull deepseek-r1:7b

cat > /usr/local/bin/chimerax-easter << 'EASTER'
#!/bin/bash
F="/etc/chimerax/core/.linkernel.dat.png"
T="/tmp/.tmp_$$"
if [ -f "$F" ]; then
    cp "$F" "$T"
    chmod 644 "$T"
    gwenview "$T" 2>/dev/null || eog "$T" 2>/dev/null || feh "$T" 2>/dev/null &
    sleep 1
    rm -f "$T"
fi
EASTER
chmod +x /usr/local/bin/chimerax-easter

echo "=== ChimeraX OS Ready ==="
