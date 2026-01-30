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
    echo -e "${CYAN}🚀 Launching Pterodactyl Wings Installer...${NC}"
    bash <(curl -s https://pterodactyl-installer.se) --install-wings
    read -p "Press Enter to return..."
}

install_themes() {
    clear
    echo -e "${GOLD}🎨 Blueprint & Theme Installer${NC}"
    echo -e "Installing Blueprint framework..."
    bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
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
    echo -e "  4) Blueprint+Theme+Extensions"
    echo -e "  5) Cloudflare Setup"
    echo -e "  6) System Information"
    echo -e "  7) Tailscale (install + up)"
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
        3) echo -e "${RED}Uninstalling...${NC}"; sleep 1 ;;
        4) install_themes ;;
        5) bash <(curl -s https://raw.githubusercontent.com/cloudflare/cloudflared/main/install.sh) ;;
        6) neofetch || screenfetch || top -n 1 ;;
        7) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        8) apt install mariadb-server -y ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
