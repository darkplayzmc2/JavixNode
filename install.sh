#!/bin/bash

# --- Color Profile (Exact Jishnu Aesthetics) ---
PINK='\033[38;5;203m'
GOLD='\033[38;5;214m'
CYAN='\033[38;5;51m'
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
NC='\033[0m' 

# --- UI Header & Watermark ---
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

# --- Management Sub-Menu ---
manage_tool() {
    local tool_name=$1
    echo -e "\n  ${GOLD}Manage: $tool_name${NC}"
    echo -e "  1) Check Status"
    echo -e "  2) Install Fresh"
    echo -e "  3) Repair / Update"
    echo -e "  4) Uninstall"
    echo -e "  5) Back"
    echo -ne "\n  Select action: "
    read -r action
    echo "$action"
}

# --- Tool Modules ---

# [1] Panel Management
manage_panel() {
    local choice=$(manage_tool "Pterodactyl Panel")
    case $choice in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${GREEN}✔ Installed${NC}" || echo -e "${RED}✘ Not Found${NC}" ;;
        2) 
            echo -ne "  ${CYAN}[INPUT]${NC} Enter FQDN: "
            read -r fqdn
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
        4) rm -rf /var/www/pterodactyl && echo "Panel Removed." ;;
    esac
}

# [5] Cloudflare Management (Fixed Installation Flow)
manage_cloudflare() {
    local choice=$(manage_tool "Cloudflare Setup")
    case $choice in
        1) systemctl is-active --quiet cloudflared && echo -e "${GREEN}✔ Active${NC}" || echo -e "${RED}✘ Inactive${NC}" ;;
        2) 
            # Step 1: Binary Download First (Crucial for execution)
            echo -e "${CYAN}🚀 Downloading cloudflared binary...${NC}"
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            sudo dpkg -i cf.deb && rm cf.deb
            
            # Step 2: Display prompt with exact SS phrasing
            echo -e "\n🔑 ${CYAN}Paste Cloudflare Tunnel token${NC}"
            echo -e "${GOLD}(sirf token ya poora command – dono chalega)${NC}"
            echo -ne "> "
            read -r cf_input
            
            # Step 3: Parse and Install
            if [[ $cf_input == *"cloudflared"* ]]; then
                eval "$cf_input"
            else
                sudo cloudflared service install "$cf_input"
            fi
            ;;
        3) sudo apt-get install --reinstall cloudflared ;;
        4) sudo cloudflared service uninstall && sudo apt remove cloudflared -y ;;
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
    
    read -r main_choice
    case $main_choice in
        1) manage_panel ;;
        5) manage_cloudflare ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
    echo -e "\n${GOLD}Execution sequence finished.${NC}"
    sleep 2
done
