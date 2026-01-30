#!/bin/bash

# --- Color Profile (Jishnu Exact) ---
PINK='\033[38;5;203m'
GOLD='\033[38;5;214m'
CYAN='\033[38;5;51m'
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
NC='\033[0m' 

# --- UI Header ---
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

# --- Cloudflare Setup with Status Check ---
setup_cloudflare() {
    clear
    echo -e "${CYAN}🚀 Cloudflare Zero Trust Manager${NC}"
    echo -e "  1) Install Tunnel"
    echo -e "  2) Check Tunnel Status"
    echo -e "  3) Back"
    echo -ne "\n  Select Option → "
    read cf_opt

    case $cf_opt in
        1)
            if ! command -v cloudflared &> /dev/null; then
                curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
                sudo dpkg -i cf.deb && rm cf.deb
            fi
            echo -e "\n🔑 ${CYAN}Paste Cloudflare Tunnel token${NC}"
            echo -e "${GOLD}(sirf token ya poora command – dono chalega)${NC}"
            echo -ne "> "
            read cf_input
            if [[ $cf_input == *"cloudflared"* ]]; then
                eval $cf_input
            else
                sudo cloudflared service install "$cf_input"
            fi
            ;;
        2)
            echo -e "\n${CYAN}🔍 Checking Systemd Service...${NC}"
            if systemctl is-active --quiet cloudflared; then
                echo -e "${GREEN}✔ Tunnel Service: ACTIVE${NC}"
                cloudflared tunnel status
            else
                echo -e "${RED}✘ Tunnel Service: INACTIVE${NC}"
            fi
            read -p "Press Enter to return..."
            ;;
        *) return ;;
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
    
    read choice
    case $choice in
        1) # Panel Logic... 
           ;;
        5) setup_cloudflare ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
