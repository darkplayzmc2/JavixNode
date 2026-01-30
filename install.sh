#!/bin/bash

# --- JavixNodes Branding & Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- Panel Installation Logic ---
install_panel() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║          PTERODACTYL CONTROL CENTER            ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -e "  ${GREEN}[1]${NC} Install Panel (Full Setup)"
    echo -e "  ${BLUE}[2]${NC} Create Administrative User"
    echo -e "  ${GOLD}[3]${NC} Update Panel"
    echo -e "  ${RED}[4]${NC} Uninstall Panel"
    echo -e "  ${NC}[5] Exit to Main Menu"
    echo -e "${GOLD}══════════════════════════════════════════════════${NC}"
    echo -ne "${CYAN}Select Option → ${NC}"
    read p_choice

    case $p_choice in
        1)
            echo -e "\n${CYAN}🚀 Launching Official Panel Installer...${NC}"
            bash <(curl -s https://pterodactyl-installer.se) --install-panel
            ;;
        2)
            echo -e "\n${BLUE}👤 Creating Admin User...${NC}"
            cd /var/www/pterodactyl && php artisan p:user:make
            ;;
        3)
            echo -e "\n${GOLD}🔄 Running Upgrade...${NC}"
            cd /var/www/pterodactyl && php artisan p:upgrade
            ;;
        4)
            echo -e "\n${RED}⚠️  Removing Panel Files...${NC}"
            rm -rf /var/www/pterodactyl
            echo -e "${GREEN}Panel files cleared.${NC}"
            sleep 2
            ;;
        5) return ;;
        *) install_panel ;;
    esac
}

# --- Wings Installation Logic (The Online Fix) ---
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
    echo -e "Go to your Panel > Nodes > Create/Select Node > Configuration."
    echo -e "Copy the block that starts with 'mkdir -p /etc/pterodactyl'."
    echo -ne "\n${GOLD}Paste Command Here → ${NC}"
    read wings_config_cmd
    eval $wings_config_cmd

    echo -e "\n${CYAN}[3/3] Starting Daemon...${NC}"
    systemctl enable --now wings
    echo -e "${GREEN}Wings setup complete. Check your Panel status!${NC}"
    read -p "Press Enter to return..."
}

# --- Main UI ---
main_menu() {
    clear
    echo -e "${GOLD}  ▟████▙      ▗▞▀▚▖     ▗▞▀▀▚▖  ▗▄▄▄▖  ▗▞▀▚▖ ${NC}"
    echo -e "${GOLD}  ▐▛  ▜▌     ▗▚▄▄▚▖     ▐▛▀▀▜▌    █    ▗▚▄▄▚▖ ${NC}"
    echo -e "${GOLD}  ▐▛  ▜▌     ▗▚▖ ▗▞▖    ▐▙▄▄▟▌  ▗▄█▄▖  ▗▚▖ ▗▞▖${NC}"
    echo -e "${GOLD}  ▜████▛     ▝▚▞▀▝▞▘     ▝▀▀▀▘  ▝▀▀▀▘  ▝▚▞▀▝▞▘${NC}"
    echo -e "         ${CYAN}⚡ JAVIXNODES v2.0 - PREMIUM EDITION ⚡${NC}"
    echo -e "            ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "  1) Panel Installation"
    echo -e "  2) Wings Installation"
    echo -e "  3) Uninstall Tools"
    echo -e "  4) Blueprint + Theme + Extensions"
    echo -e "  5) Cloudflare Setup"
    echo -e "  6) System Information"
    echo -e "  7) Tailscale (Install + Up)"
    echo -e "  8) Database Setup"
    echo -e "  0) Exit"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${CYAN}Select an option [0-8]: ${NC}"
}

# --- Main Loop ---
while true; do
    main_menu
    read choice
    case $choice in
        1) install_panel ;;
        2) install_wings ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo -e "${RED}Wiped.${NC}"; sleep 1 ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb && dpkg -i cloudflared.deb ;;
        6) neofetch || top -n 1 ;;
        7) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
