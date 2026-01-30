#!/bin/bash

# --- Javix Professional Branding ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

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
    echo -e "           ${CYAN}JAVIXNODES DEVELOPMENT MANAGEMENT CONSOLE${NC}"
    echo -e "              ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}════════════════════════════════════════════════════════════════════${NC}"
}

# --- Confirmation Wrapper ---
# Asks "Install or Delete" before every action
confirm_action() {
    local tool_name=$1
    echo -e "\n${GOLD}Selected: $tool_name${NC}"
    echo -e "${CYAN}1) Install / Setup${NC}"
    echo -e "${RED}2) Delete / Remove${NC}"
    echo -e "3) Back${NC}"
    echo -ne "\nAction: "
    read action_choice
    echo $action_choice
}

# --- Tool Modules ---
manage_panel() {
    local choice=$(confirm_action "Panel Installation")
    if [ "$choice" == "1" ]; then
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
    elif [ "$choice" == "2" ]; then
        rm -rf /var/www/pterodactyl
        echo "Panel files removed."
        sleep 1
    fi
}

manage_wings() {
    local choice=$(confirm_action "Wings Installation")
    if [ "$choice" == "1" ]; then
        echo -ne "Paste JSON Config: "
        read -r json
        mkdir -p /etc/pterodactyl && echo "$json" > /etc/pterodactyl/config.yml
        systemctl enable --now wings
    elif [ "$choice" == "2" ]; then
        systemctl stop wings
        rm -rf /etc/pterodactyl /usr/local/bin/wings
        echo "Wings removed."
        sleep 1
    fi
}

# --- Main Selection Loop ---
while true; do
    show_header
    echo -e "  [1] Tailscale Setup"
    echo -e "  [2] Cloudflare Tunnel"
    echo -e "  [3] Panel Installation"
    echo -e "  [4] Wings Installation"
    echo -e "  [5] System Information"
    echo -e "  [0] Exit"
    echo -e "${GOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo -ne "Choice: "
    
    read main_choice
    case $main_choice in
        1) manage_tailscale ;; # You can add Tailscale logic here
        2) manage_cloudflare ;; # You can add Cloudflare logic here
        3) manage_panel ;;
        4) manage_wings ;;
        5) neofetch || top -n 1 ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
