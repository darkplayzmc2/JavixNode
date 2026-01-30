#!/bin/bash

# --- Color Profile (Jishnu Aesthetics) ---
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
# This ensures a secondary menu for every single option
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

# --- Module: Panel (Option 1) ---
manage_panel() {
    local choice=$(manage_tool "Pterodactyl Panel")
    case $choice in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${GREEN}✔ Installed${NC}" || echo -e "${RED}✘ Not Found${NC}" ;;
        2) 
            echo -e "${CYAN}Launching official installer...${NC}"
            # Reverting to interactive mode for reliability
            bash <(curl -s https://pterodactyl-installer.se) --install-panel 
            ;;
        3) cd /var/www/pterodactyl && php artisan p:upgrade ;;
        4) rm -rf /var/www/pterodactyl && echo "Panel Removed." ;;
    esac
}

# --- Module: Cloudflare (Option 5) ---
manage_cloudflare() {
    local choice=$(manage_tool "Cloudflare Setup")
    case $choice in
        1) systemctl is-active --quiet cloudflared && echo -e "${GREEN}✔ Active${NC}" || echo -e "${RED}✘ Inactive${NC}" ;;
        2) 
            # Force download before prompt to ensure cmd exists
            echo -e "${CYAN}🚀 Downloading cloudflared binary...${NC}"
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            sudo dpkg -i cf.deb && rm cf.deb
            
            echo -e "\n🔑 ${CYAN}Paste Cloudflare Tunnel token${NC}"
            echo -e "${GOLD}(sirf token ya poora command – dono chalega)${NC}"
            echo -ne "> "
            read -r cf_input
            [[ $cf_input == *"cloudflared"* ]] && eval "$cf_input" || sudo cloudflared service install "$cf_input"
            ;;
        3) sudo apt-get install --reinstall cloudflared ;;
        4) sudo cloudflared service uninstall && sudo apt remove cloudflared -y ;;
    esac
}

# --- Module: Tailscale (Option 7) ---
manage_tailscale() {
    local choice=$(manage_tool "Tailscale")
    case $choice in
        1) tailscale status ;;
        2) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        3) apt-get install --reinstall tailscale ;;
        4) tailscale down && apt remove tailscale -y ;;
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
        2) manage_tool "Wings" ;; 
        3) # Deep clean logic
           rm -rf /var/www/pterodactyl /etc/pterodactyl /usr/local/bin/wings
           echo "System wiped." ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) manage_cloudflare ;;
        6) neofetch || top -n 1 | head -n 20; read -p "Enter..." ;;
        7) manage_tailscale ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
    echo -e "\n${GOLD}Task sequence completed.${NC}"
    sleep 2
done
