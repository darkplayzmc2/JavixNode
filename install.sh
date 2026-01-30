#!/bin/bash

# --- Javix Brand Colors ---
V1='\033[38;5;129m' # Electric Violet
G1='\033[38;5;118m' # Neon Green
C1='\033[38;5;45m'  # Deep Cyan
R1='\033[38;5;196m' # Pulse Red
Y1='\033[38;5;220m' # Cyber Yellow
NC='\033[0m' 

# --- UI Header & Branded Watermark ---
draw_sep() {
    echo -e "${V1}◈────────────────────────────────────────────────────────────◈${NC}"
}

show_header() {
    clear
    draw_sep
    echo -e "          ${Y1}🚀 JAVIX HOSTING MANAGER${NC}"
    echo -e "          ${C1}developed by sk mohsin pasha${NC}"
    draw_sep
    echo -e "${Y1}"
    echo -e "     ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗ ███████╗ "
    echo -e "     ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗██╔════╝ "
    echo -e "     ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║█████╗   "
    echo -e "██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║██╔══╝   "
    echo -e "╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝███████╗ "
    echo -e " ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝ "
    echo -e "${NC}"
    draw_sep
}

# --- Standardized Management Sub-Menu ---
# Ensures a 2nd menu for every option as requested
manage_tool() {
    local tool_name=$1
    echo -e "\n  ${Y1}MANAGEMENT HUB: $tool_name${NC}"
    echo -e "  ${C1}1)${NC} Check Status"
    echo -e "  ${C1}2)${NC} Install Fresh"
    echo -e "  ${C1}3)${NC} Repair / Upgrade"
    echo -e "  ${C1}4)${NC} Uninstall"
    echo -e "  ${C1}5)${NC} Return to Menu"
    echo -ne "\n  ${G1}Select Action > ${NC}"
    read -r sub_choice
}

# --- Module: Panel (Option 1) ---
manage_panel() {
    manage_tool "Pterodactyl Panel"
    case $sub_choice in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}✔ Installed${NC}" || echo -e "${R1}✘ Not Found${NC}" ;;
        2) bash <(curl -s https://pterodactyl-installer.se) --install-panel ;;
        3) cd /var/www/pterodactyl && php artisan p:upgrade ;;
        4) rm -rf /var/www/pterodactyl && echo -e "${R1}Panel Purged.${NC}" ;;
    esac
}

# --- Module: Cloudflare (Option 5) ---
manage_cloudflare() {
    manage_tool "Cloudflare Zero Trust"
    case $sub_choice in
        1) systemctl is-active --quiet cloudflared && echo -e "${G1}✔ Service Active${NC}" || echo -e "${R1}✘ Inactive${NC}" ;;
        2) 
            echo -e "${C1}🚀 Downloading Cloudflare binary...${NC}"
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            sudo dpkg -i cf.deb && rm cf.deb
            echo -e "\n🔑 ${C1}Paste Cloudflare Tunnel token${NC}"
            echo -e "${Y1}(sirf token ya poora command – dono chalega)${NC}"
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
    manage_tool "Tailscale VPN"
    case $sub_choice in
        1) tailscale status ;;
        2) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        3) apt-get install --reinstall tailscale ;;
        4) tailscale down && apt remove tailscale -y ;;
    esac
}

# --- Main Selection Loop ---
while true; do
    show_header
    echo -e "  ${C1}[1]${NC} Panel Installation      ${C1}[5]${NC} Cloudflare Setup"
    echo -e "  ${C1}[2]${NC} Wings Installation      ${C1}[6]${NC} System Information"
    echo -e "  ${C1}[3]${NC} Deep System Purge       ${C1}[7]${NC} Tailscale (VPN)"
    echo -e "  ${C1}[4]${NC} Theme / Extensions      ${C1}[8]${NC} Database Setup"
    echo -e "  ${C1}[0]${NC} Terminate Session"
    draw_sep
    echo -ne "  ${G1}JAVIX_OS@ROOT:~$ ${NC}"
    
    read -r choice
    case $choice in
        1) manage_panel ;;
        2) manage_tool "Wings" ;; 
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl; echo -e "${R1}Wiped.${NC}" ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) manage_cloudflare ;;
        6) neofetch || top -n 1 | head -n 20; read -p "Enter..." ;;
        7) manage_tailscale ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
    echo -e "\n${Y1}Operation complete. Returning to HUB...${NC}"
    sleep 2
done
