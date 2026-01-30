#!/bin/bash

# --- Colors & Aesthetics ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# --- UI Components ---
draw_line() {
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
}

draw_box_top() {
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
}

draw_box_bottom() {
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
}

# --- Functional Logic ---
silent_kernel_install() {
    clear
    draw_box_top
    echo -e "║${CYAN}   🧬  INITIALIZING KERNEL PANEL DEPLOYMENT...   ${NC}║"
    draw_box_bottom
    sleep 1
    # Automated input for Pterodactyl Panel
    bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
y
y
y
EOF
}

ghost_handshake() {
    clear
    draw_box_top
    echo -e "║${PURPLE}   👻  GHOST HANDSHAKE: WINGS SECURE LINK        ${NC}║"
    draw_box_bottom
    echo -e "\n${BLUE}📂 Please paste your Panel Configuration JSON below:${NC}"
    read -r ghost_config

    mkdir -p /etc/pterodactyl
    echo "$ghost_config" > /etc/pterodactyl/config.yml
    
    systemctl enable --now wings
    echo -e "\n${GREEN}✔ HANDSHAKE SUCCESSFUL: NODE IS ONLINE${NC}"
    read -p "Press Enter to return..."
}

# --- Main HUD ---
main_hud() {
    clear
    # Real-time System Pulse calculation
    local cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo -e "${PURPLE}⟨${NC} ${GOLD}CPU LOAD:${NC} $cpu% ${PURPLE}│${NC} ${GOLD}STATUS:${NC} SECURE ${PURPLE}│${NC} ${GOLD}BRAND:${NC} JAVIXNODE ${PURPLE}⟩${NC}"
    
    echo -e "${GOLD}      ▟████▙      ▗▞▀▚▖     ▗▞▀▀▚▖  ▗▄▄▄▖  ▗▞▀▚▖ ${NC}"
    echo -e "${GOLD}      ▐▛  ▜▌     ▗▚▄▄▚▖     ▐▛▀▀▜▌    █    ▗▚▄▄▚▖ ${NC}"
    echo -e "${GOLD}      ▐▛  ▜▌     ▗▚▖ ▗▞▖    ▐▙▄▄▟▌  ▗▄█▄▖  ▗▚▖ ▗▞▖${NC}"
    echo -e "${GOLD}      ▜████▛     ▝▚▞▀▝▞▘     ▝▀▀▀▘  ▝▀▀▀▘  ▝▚▞▀▝▞▘${NC}"
    
    draw_line
    echo -e "  ${CYAN}[1]${NC} 🧬 Kernel Panel Deployment    ${CYAN}[4]${NC} 🛡️ ZeroTrust Tunnel"
    echo -e "  ${CYAN}[2]${NC} 👻 Ghost Wings Handshake      ${CYAN}[5]${NC} 📊 Hardware Matrix"
    echo -e "  ${CYAN}[3]${NC} 🧹 Deep System Purge          ${CYAN}[0]${NC} 🚪 Terminate Uplink"
    draw_line
    echo -ne "${CYAN}JAVIX_OS@ROOT:~$ ${NC}"
}

# --- Loop ---
while true; do
    main_hud
    read choice
    case $choice in
        1) silent_kernel_install ;;
        2) ghost_handshake ;;
        3) 
           echo -e "${RED}🧹 PURGING SYSTEM FILES...${NC}"
           rm -rf /var/www/pterodactyl /etc/pterodactyl
           sleep 1 
           ;;
        4) 
           echo -e "${BLUE}🛡️ DEPLOYING ZERO TRUST TUNNEL...${NC}"
           curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
           dpkg -i cf.deb && rm cf.deb
           cloudflared tunnel login
           ;;
        5) neofetch || top -n 1 ;;
        0) clear; echo -e "${RED}🚪 Uplink Terminated.${NC}"; exit 0 ;;
        *) sleep 1 ;;
    esac
done
