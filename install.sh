#!/bin/bash

# --- JavixNodes Branding & Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- Modular Functions ---

install_panel() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║          PTERODACTYL CONTROL CENTER            ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -e "  ${GREEN}[1]${NC} Install Panel"
    echo -e "  ${BLUE}[2]${NC} Create Panel User"
    echo -e "  ${GOLD}[3]${NC} Update Panel"
    echo -e "  ${RED}[4]${NC} Uninstall Panel"
    echo -e "  ${NC}[5] Exit"
    echo -ne "\n${CYAN}Select Option → ${NC}"
    read p_choice
    case $p_choice in
        1) bash <(curl -s https://pterodactyl-installer.se) --install-panel ;;
        2) cd /var/www/pterodactyl && php artisan p:user:make ;;
        3) cd /var/www/pterodactyl && php artisan p:upgrade ;;
        4) echo -e "${RED}Deleting Panel files...${NC}"; rm -rf /var/www/pterodactyl ;;
        *) return ;;
    esac
}

install_wings() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║          JAVIXNODE WINGS CONFIGURATOR          ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    echo -e "${CYAN}[1/3] Installing Dependencies...${NC}"
    curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    systemctl enable --now docker

    echo -e "${CYAN}[2/3] Installing Wings Binary...${NC}"
    mkdir -p /etc/pterodactyl
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
    chmod u+x /usr/local/bin/wings

    echo -e "\n${RED}⚠️  MANDATORY CONFIGURATION:${NC}"
    echo -e "Go to your Panel > Nodes > Configuration and copy the block."
    echo -ne "\n${GOLD}Paste Command Here → ${NC}"
    read wings_config_cmd
    eval $wings_config_cmd

    echo -e "\n${CYAN}[3/3] Starting Daemon...${NC}"
    systemctl enable --now wings
    echo -e "${GREEN}Wings setup complete. Check your Panel status!${NC}"
    read -p "Press Enter to return..."
}

install_cloudflare() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║          CLOUDFLARE ZERO TRUST SETUP           ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    echo -e "${CYAN}[1/3] Installing Cloudflared...${NC}"
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
    sudo dpkg -i cloudflared.deb && rm cloudflared.deb

    echo -e "\n${CYAN}[2/3] Authenticating with Cloudflare...${NC}"
    echo -e "${GOLD}Click the link that appears below to login to your account.${NC}"
    cloudflared tunnel login

    echo -e "\n${CYAN}[3/3] Creating Your Tunnel...${NC}"
    read -p "Enter a name for your tunnel (e.g., javix-panel): " tname
    cloudflared tunnel create $tname
    
    echo -e "\n${GREEN}Tunnel Created! Use 'cloudflared tunnel run $tname' to start.${NC}"
    read -p "Press Enter to return..."
}

# --- Main UI ---
main_menu() {
    clear
    echo -e "${GOLD}  ▟████▙      ▗▞▀▚▖     ▗▞▀▀▚▖  ▗▄▄▄▖  ▗▞▀▚▖ ${NC}"
    echo -e "${GOLD}  ▐▛  ▜▌     ▗▚▄▄▚▖     ▐▛▀▀▜▌    █    ▗▚▄▄▚▖ ${NC}"
    echo -e "${GOLD}  ▐▛  ▜▌     ▗▚▖ ▗▞▖    ▐▙▄▄▟▌  ▗▄█▄▖  ▗▚▖ ▗▞▖${NC}"
    echo -e "${GOLD}  ▜████▛     ▝▚▞▀▝▞▘     ▝▀▀▀▘  ▝▀▀▀▘  ▝▚▞▀▝▞▘${NC}"
    echo -e "         ${CYAN}⚡ JAVIXNODES HOSTING MANAGER ⚡${NC}"
    echo -e "            ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "  1) Panel Installation"
    echo -e "  2) Wings Installation"
    echo -e "  3) Uninstall Tools"
    echo -e "  4) Blueprint + Theme + Extensions"
    echo -e "  5) Cloudflare Zero Trust Setup"
    echo -e "  6) System Information"
    echo -e "  7) Tailscale (Install + Up)"
    echo -e "  8) Database Setup"
    echo -e "  0) Exit"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${CYAN}Select an option [0-8]: ${NC}"
}

while true; do
    main_menu
    read choice
    case $choice in
        1) install_panel ;;
        2) install_wings ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo -e "${RED}Wiped.${NC}"; sleep 1 ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) install_cloudflare ;;
        6) neofetch || top -n 1 ;;
        7) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
