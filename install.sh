#!/bin/bash

# --- Javix Neon Aesthetics ---
G1='\033[38;5;220m' # Javix Gold
C1='\033[38;5;51m'  # Cyber Cyan
P1='\033[38;5;13m'  # Phantom Purple
R1='\033[38;5;196m' # Pulse Red
NC='\033[0m'

# --- The "Silent Kernel" Logic ---
# This bypasses the manual prompts for the Panel installation
javix_kernel_install() {
    clear
    echo -e "${C1}▶ INITIALIZING JAVIX KERNEL DEPLOYMENT...${NC}"
    sleep 1
    # Automated input stream to handle Panel setup
    bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
y
y
y
EOF
}

# --- The "Ghost Handshake" Wings Setup ---
# Injects the JSON config directly into the system for instant linking
ghost_handshake() {
    clear
    echo -e "${G1}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║          GHOST HANDSHAKE: WINGS LINK           ║"
    echo -e "╚════════════════════════════════════════════════╝${NC}"
    echo -e "${P1}Paste your Panel Configuration JSON below:${NC}"
    read -r ghost_config

    mkdir -p /etc/pterodactyl
    echo "$ghost_config" > /etc/pterodactyl/config.yml
    
    # Priority daemon start
    systemctl enable --now wings
    echo -e "\n${C1}✔ HANDSHAKE SUCCESSFUL: NODE ONLINE${NC}"
    sleep 2
}

# --- Zero Trust Tunnel Logic ---
install_cloudflare() {
    clear
    echo -e "${C1}▶ DEPLOYING CLOUDFLARE ZERO TRUST TUNNEL...${NC}"
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
    dpkg -i cf.deb && rm cf.deb
    cloudflared tunnel login
}

# --- Advanced Main HUD (Head-Up Display) ---
main_hud() {
    clear
    # Real-time System Pulse calculation
    local cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo -e "${P1}⟨${NC} ${G1}CPU LOAD:${NC} $cpu% ${P1}│${NC} ${G1}STATUS:${NC} SECURE ${P1}│${NC} ${G1}BRAND:${NC} JAVIXNODE ${P1}⟩${NC}"
    
    echo -e "${G1}      ▟████▙      ▗▞▀▚▖     ▗▞▀▀▚▖  ▗▄▄▄▖  ▗▞▀▚▖ ${NC}"
    echo -e "${G1}      ▐▛  ▜▌     ▗▚▄▄▚▖     ▐▛▀▀▜▌    █    ▗▚▄▄▚▖ ${NC}"
    echo -e "${G1}      ▐▛  ▜▌     ▗▚▖ ▗▞▖    ▐▙▄▄▟▌  ▗▄█▄▖  ▗▚▖ ▗▞▖${NC}"
    echo -e "${G1}      ▜████▛     ▝▚▞▀▝▞▘     ▝▀▀▀▘  ▝▀▀▀▘  ▝▚▞▀▝▞▘${NC}"
    
    echo -e "${P1}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "  ${C1}[1]${NC} 🧬 Kernel Panel Deployment    ${C1}[4]${NC} 🛡️ ZeroTrust Tunnel"
    echo -e "  ${C1}[2]${NC} 👻 Ghost Wings Handshake      ${C1}[5]${NC} 📊 Hardware Matrix"
    echo -e "  ${C1}[3]${NC} 🧹 Deep System Purge          ${C1}[0]${NC} 🚪 Terminate Uplink"
    echo -e "${P1}══════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${C1}JAVIX_OS@ROOT:~$ ${NC}"
}

# --- Operation Loop ---
while true; do
    main_hud
    read choice
    case $choice in
        1) javix_kernel_install ;;
        2) ghost_handshake ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo "SYSTEM PURGED"; sleep 1 ;;
        4) install_cloudflare ;;
        5) neofetch || top -n 1 ;;
        0) clear; echo -e "${R1}Uplink Terminated.${NC}"; exit 0 ;;
        *) sleep 1 ;;
    esac
done
