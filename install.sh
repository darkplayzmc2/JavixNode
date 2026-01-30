#!/bin/bash

# --- Javix Brand Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

# --- Step 1: Tailscale IP Acquisition ---
install_tailscale() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}         🌐  STEP 1: TAILSCALE IP SETUP           ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Installing Tailscale to secure your Node IP...${NC}"
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    echo -e "\n${GREEN}✔ Your Tailscale IP is: $(tailscale ip -4)${NC}"
    read -p "Press Enter to proceed to Cloudflare Setup..."
}

# --- Step 2: Cloudflare Zero Trust (Token Method) ---
install_cloudflare() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}         🛡️  STEP 2: CLOUDFLARE TUNNEL            ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    # Check if cloudflared is installed
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${CYAN}Installing cloudflared binary...${NC}"
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
        dpkg -i cf.deb && rm cf.deb
    fi

    echo -e "${GOLD}Please go to the Cloudflare Zero Trust Dashboard.${NC}"
    echo -e "Copy your ${CYAN}Tunnel Token${NC} or the ${CYAN}Full Install Command${NC}."
    echo -ne "\n${CYAN}[INPUT]${NC} Paste Token/Command: "
    read cf_input

    # Logic to handle if they paste the full 'cloudflared.exe service install...' command
    if [[ $cf_input == *"cloudflared"* ]]; then
        eval $cf_input
    else
        cloudflared service install $cf_input
    fi

    echo -e "\n${GREEN}✔ Cloudflare Tunnel is now active!${NC}"
    read -p "Press Enter to start Panel Installation..."
}

# --- Step 3: Auto-FQDN Panel Installation ---
auto_panel_install() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "║${CYAN}         🖥️  STEP 3: JAVIX PANEL DEPLOY          ${NC}║"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    echo -ne "${CYAN}[INPUT]${NC} Enter your FQDN (from Cloudflare DNS): "
    read fqdn
    
    echo -e "\n${GREEN}🚀 Auto-installing dependencies for $fqdn...${NC}"
    # Automated input stream for Pterodactyl
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
}

# --- UI Header ---
show_header() {
    clear
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

# --- Main Logic ---
while true; do
    show_header
    echo -e "  ${CYAN}[1]${NC} 🚀 Full Deployment (Tailscale + Tunnel + Panel)"
    echo -e "  ${CYAN}[2]${NC} 👻 Ghost Wings Handshake"
    echo -e "  ${CYAN}[3]${NC} 🧹 Deep System Purge"
    echo -e "  ${CYAN}[0]${NC} 👋 Terminate Session"
    echo -e "${GOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${CYAN}[JAVIX]${NC} Selection: "
    read choice
    case $choice in
        1) install_tailscale && install_cloudflare && auto_panel_install ;;
        2) 
           echo -ne "Paste JSON Config: "
           read -r gc
           mkdir -p /etc/pterodactyl && echo "$gc" > /etc/pterodactyl/config.yml
           systemctl enable --now wings ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; sleep 1 ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
