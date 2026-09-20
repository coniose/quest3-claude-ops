#!/data/data/com.termux/files/usr/bin/bash
# Termux:Widget shortcut — copiar para ~/.shortcuts/iniciar-ssh.sh no Quest
# (chmod +x depois de copiar). Cria um icone na tela inicial via app
# Termux:Widget que roda isto com um toque, sem abrir o terminal.

termux-wake-lock
pgrep -x sshd >/dev/null || sshd
echo "sshd ativo. IP:"
ip addr show wlan0 2>/dev/null | grep "inet " || ifconfig wlan0 2>/dev/null | grep "inet "
termux-toast "SSH pronto (porta 8022)" 2>/dev/null
