#!/bin/bash

# --- Javix Brand Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- UI Header & Watermark ---
show_header() {
    clear
    # Professional ASCII Art based on your screenshots
    echo -e "${GOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "║${NC}       ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗ ███████╗ ${NC}║"
    echo -e "║${NC}       ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗██╔════╝ ${NC}║"
    echo -e "║${NC}       ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║█████╗   ${NC}║"
    echo -e "║${NC}  ██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ${NC}║"
    echo -e "║${NC}  ╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝███████╗ ${NC}║"
    echo -e "║${NC}   ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝ ${NC}║"
    echo -e "${GOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "           ${CYAN}⚡ JAVIXNODES NETWORK MANAGER ⚡${NC}"
    echo -e "              ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}════════════════════════════════════════════════════════════════════${NC}"
}

# --- Independent Tool Options ---

# Option 1: Tailscale (Secure IP Acquisition)
setup_tailscale() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}          🌐  TAILSCALE NETWORK SETUP            ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    echo -e "\n${GREEN}✔ Node IP: $(tailscale ip -4)${NC}"
    read -p "Press Enter to return..."
}

# Option 2: Cloudflare Zero Trust (Supports Token or Full Command)
setup_cloudflare() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}          🛡️  CLOUDFLARE TUNNEL SETUP            ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    if ! command -v cloudflared &> /dev/null; then
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
        sudo dpkg -i cf.deb && rm cf.deb
    fi

    echo -e "${GOLD}Paste your Tunnel Token or the full Install Command:${NC}"
    echo -ne "\n${CYAN}[INPUT]${NC} Token/Command: "
    read cf_input

    if [[ $cf_input == *"cloudflared"* ]]; then
        eval $cf_input
    else
        sudo cloudflared service install $cf_input
    fi
    echo -e "\n${GREEN}✔ Tunnel established successfully.${NC}"
    read -p "Press Enter to return..."
}

# Option 3: Automated Panel (Auto-FQDN Mode)
setup_panel() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}         🖥️  AUTO-FQDN PANEL INSTALLER           ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    echo -ne "${CYAN}[INPUT]${NC} Enter FQDN: "
    read fqdn
    
    # Automated input feeding for silent installation
    bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
$fqdn
UTC
flashnodeswork@gmail.com
pterodactyl
pterodactyl
$(openssl rand -base64 12)
y
y
y
EOF
    read -p "Press Enter to return..."
}

# Option 4: Wings Ghost Handshake (Instant Link)
setup_wings() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${GOLD}          👻  GHOST WINGS HANDSHAKE              ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -ne "${CYAN}[INPUT]${NC} Paste Configuration JSON: "
    read -r config_json
    mkdir -p /etc/pterodactyl && echo "$config_json" > /etc/pterodactyl/config.yml
    systemctl enable --now wings
    echo -e "\n${GREEN}✔ Node is online.${NC}"
    read -p "Press Enter to return..."
}

# --- Main Selection Loop ---
while true; do
    show_header
    echo -e "  ${CYAN}[1]${NC} 🌐 Tailscale IP Setup"
    echo -e "  ${CYAN}[2]${NC} 🛡️  Cloudflare Tunnel (Token/Cmd)"
    echo -e "  ${CYAN}[3]${NC} 🚀 Auto Panel Installation (FQDN)"
    echo -e "  ${CYAN}[4]${NC} 👻 Ghost Wings Handshake"
    echo -e "  ${CYAN}[5]${NC} 🧹 Deep System Purge"
    echo -e "  ${CYAN}[0]${NC} 👋 Exit Manager"
    echo -e "${GOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${CYAN}[JAVIX]${NC} Choice: "
    
    read choice
    case $choice in
        1) setup_tailscale ;;
        2) setup_cloudflare ;;
        3) setup_panel ;;
        4) setup_wings ;;
        5) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo "Purged."; sleep 1 ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
