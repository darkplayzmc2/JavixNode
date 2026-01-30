#!/bin/bash

# --- Color Profile (Jishnu Style) ---
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

# --- Action Wrapper ---
# Standardizes the "Install or Delete" prompt for every option
select_action() {
    local tool=$1
    echo -e "\n  Selected: ${CYAN}$tool${NC}"
    echo -e "  1) Install / Setup"
    echo -e "  2) Uninstall / Delete"
    echo -e "  3) Back"
    echo -ne "\n  Select an action: "
    read action
    echo $action
}

# --- Tool Modules ---

manage_panel() {
    local act=$(select_action "Panel Installation")
    if [ "$act" == "1" ]; then
        echo -ne "  Enter FQDN: "
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
    elif [ "$act" == "2" ]; then
        rm -rf /var/www/pterodactyl
        echo -e "${RED}Panel removed.${NC}"
        sleep 1
    fi
}

manage_wings() {
    local act=$(select_action "Wings Installation")
    if [ "$act" == "1" ]; then
        echo -ne "  Paste JSON Config: "
        read -r json
        mkdir -p /etc/pterodactyl && echo "$json" > /etc/pterodactyl/config.yml
        systemctl enable --now wings
    elif [ "$act" == "2" ]; then
        systemctl stop wings
        rm -rf /etc/pterodactyl /usr/local/bin/wings
        echo -e "${RED}Wings removed.${NC}"
        sleep 1
    fi
}

manage_tailscale() {
    local act=$(select_action "Tailscale")
    if [ "$act" == "1" ]; then
        curl -fsSL https://tailscale.com/install.sh | sh && tailscale up
    elif [ "$act" == "2" ]; then
        tailscale down && apt remove tailscale -y
    fi
}

manage_cloudflare() {
    local act=$(select_action "Cloudflare Setup")
    if [ "$act" == "1" ]; then
        echo -ne "  Paste Token/Cmd: "
        read cf_input
        if [[ $cf_input == *"cloudflared"* ]]; then eval $cf_input; else cloudflared service install $cf_input; fi
    elif [ "$act" == "2" ]; then
        cloudflared service uninstall
        rm -rf /etc/cloudflared
    fi
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
    
    read choice
    case $choice in
        1) manage_panel ;;
        2) manage_wings ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo "Purged."; sleep 1 ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) manage_cloudflare ;;
        6) neofetch || top -n 1 ;;
        7) manage_tailscale ;;
        8) apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
