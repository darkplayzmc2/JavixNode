#!/bin/bash

# --- Color Profile (Jishnu Exact) ---
PINK='\033[38;5;203m'
GOLD='\033[38;5;214m'
CYAN='\033[38;5;51m'
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
NC='\033[0m' 

# --- UI Components ---
draw_line() {
    echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

show_header() {
    clear
    draw_line
    echo -e "          🚀 JAVIX HOSTING MANAGER"
    echo -e "          made by sk mohsin pasha"
    draw_line
    echo -e "${NC}"
    echo -e "  __  __   _   ___ _  _   __  __ ___ _  _ _   _ "
    echo -e " |  \/  | /_\ |_ _| \| | |  \/  | __| \| | | | |"
    echo -e " | |\/| |/ _ \ | || .  | | |\/| | _|| .  | |_| |"
    echo -e " |_|  |_/_/ \_\___|_|\_| |_|  |_|___|_|\_|\___/ "
    echo -e "${NC}"
    draw_line
}

# --- Standardized Management Sub-Menu ---
# This ensures every option asks for Status, Install, Repair, or Uninstall
manage_tool() {
    local tool_name=$1
    echo -e "\n  ${GOLD}Manage: $tool_name${NC}"
    echo -e "  1) Check Status"
    echo -e "  2) Install Fresh"
    echo -e "  3) Repair"
    echo -e "  4) Uninstall"
    echo -e "  5) Back"
    echo -ne "\n  Select action: "
    read action
    echo $action
}

# --- Cloudflare Module (Fixed) ---
manage_cloudflare() {
    local choice=$(manage_tool "Cloudflare Zero Trust")
    case $choice in
        1) systemctl status cloudflared ;;
        2) 
            echo -e "${CYAN}Downloading cloudflared binary...${NC}"
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            sudo dpkg -i cf.deb && rm cf.deb
            echo -e "🔑 ${CYAN}Paste Cloudflare Tunnel token${NC}"
            echo -e "${GOLD}(sirf token ya poora command – dono chalega)${NC}"
            echo -ne "> "
            read cf_input
            [[ $cf_input == *"cloudflared"* ]] && eval $cf_input || sudo cloudflared service install "$cf_input"
            ;;
        3) sudo apt-get install --reinstall cloudflared ;;
        4) sudo cloudflared service uninstall && sudo apt remove cloudflared -y ;;
    esac
}

# --- Panel Module ---
manage_panel() {
    local choice=$(manage_tool "Pterodactyl Panel")
    case $choice in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${GREEN}Installed${NC}" || echo -e "${RED}Not Found${NC}" ;;
        2) 
            echo -ne "Enter FQDN: "
            read fqdn
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
            ;;
        3) cd /var/www/pterodactyl && php artisan p:upgrade ;;
        4) rm -rf /var/www/pterodactyl ;;
    esac
}

# --- Main Selection Loop ---
while true; do
    show_header
    echo -e "  ${CYAN}1)${NC} Panel Installation"
    echo -e "  ${CYAN}2)${NC} Wings Installation"
    echo -e "  ${CYAN}3)${NC} Uninstall Tools (Deep Clean)"
    echo -e "  ${CYAN}4)${NC} Blueprint+Theme+Extensions"
    echo -e "  ${CYAN}5)${NC} Cloudflare Setup"
    echo -e "  ${CYAN}6)${NC} System Information"
    echo -e "  ${CYAN}7)${NC} Tailscale (install + up)"
    echo -e "  ${CYAN}8)${NC} Database Setup"
    echo -e "  ${CYAN}0)${NC} Exit"
    draw_line
    echo -ne "  📝 Select an option [0-8]: "
    
    read main_choice
    case $main_choice in
        1) manage_panel ;;
        2) manage_tool "Wings" ;; # Add specific Wings logic here
        5) manage_cloudflare ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
