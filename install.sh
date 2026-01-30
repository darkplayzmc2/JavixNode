#!/bin/bash

# --- Javix Brand Colors ---
V1='\033[38;5;129m' # Electric Violet
G1='\033[38;5;118m' # Neon Green
C1='\033[38;5;45m'  # Deep Cyan
R1='\033[38;5;196m' # Pulse Red
Y1='\033[38;5;220m' # Cyber Yellow
NC='\033[0m' 

# --- UI Header ---
draw_sep() {
    echo -e "${V1}◈────────────────────────────────────────────────────────────◈${NC}"
}

show_header() {
    clear
    draw_sep
    echo -e "          ${Y1}🚀 JAVIX PRO: FULLY OPERATIONAL EDITION${NC}"
    echo -e "          ${C1}developed by sk mohsin pasha${NC}"
    draw_sep
    echo -e "${Y1}     ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗"
    echo -e "     ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗"
    echo -e "     ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║"
    echo -e "██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║"
    echo -e "╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝"
    draw_sep
}

# --- Persistent Hub Hub (Ensures tools don't just reload main menu) ---
manage_tool() {
    local tool_name=$1
    local action_func=$2
    while true; do
        echo -e "\n  ${Y1}HUB: $tool_name${NC}"
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install Fresh (Automated)"
        echo -e "  ${C1}3)${NC} Repair / Update"
        echo -e "  ${C1}4)${NC} Uninstall"
        echo -e "  ${C1}5)${NC} Back to Main Menu"
        echo -e "  ${R1}6) Exit Script${NC}"
        echo -ne "\n  ${G1}Select Action > ${NC}"
        read -r sub_choice

        if [ "$sub_choice" == "5" ]; then break; fi
        if [ "$sub_choice" == "6" ]; then exit 0; fi

        # Execute the specific logic for this tool
        $action_func "$sub_choice"
        
        echo -ne "\n${Y1}Action Finished. Press [Enter] to continue...${NC}"
        read -r
    done
}

# --- Individual Logic Modules ---
panel_logic() {
    case $1 in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}✔ Installed${NC}" || echo -e "${R1}✘ Not Found${NC}" ;;
        2) 
            echo -ne "Domain: " && read fqdn
            echo -ne "Email: " && read email
            bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
$fqdn
UTC
$email
admin
admin
$(openssl rand -base64 12)
y
y
y
EOF
            ;;
        4) rm -rf /var/www/pterodactyl ;;
    esac
}

cloudflare_logic() {
    case $1 in
        1) systemctl is-active --quiet cloudflared && echo -e "${G1}✔ Active${NC}" || echo -e "${R1}✘ Inactive${NC}" ;;
        2) 
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            echo -ne "Token: " && read token
            cloudflared service install "$token"
            ;;
    esac
}

# --- Main Menu ---
while true; do
    show_header
    echo -e "  ${C1}[1]${NC} Panel Hub             ${C1}[9]${NC} Blueprint Engine"
    echo -e "  ${C1}[2]${NC} Wings Hub             ${C1}[10]${NC} Theme Installer"
    echo -e "  ${C1}[3]${NC} Resource Optimizer    ${C1}[11]${NC} GHOST COMBO (Auto)"
    echo -e "  ${C1}[4]${NC} Automatic Backups     ${C1}[12]${NC} SSL Auto-Cert"
    echo -e "  ${C1}[5]${NC} Cloudflare Hub        ${C1}[13]${NC} Node.js Manager"
    echo -e "  ${C1}[6]${NC} Tailscale VPN         ${C1}[14]${NC} Discord Bot Host"
    echo -e "  ${C1}[7]${NC} Security Hardening    ${C1}[15]${NC} Live System Logs"
    echo -e "  ${C1}[0]${NC} Exit Session"
    draw_sep
    echo -ne "  ${G1}JAVIX_OS@ROOT:~$ ${NC}"
    
    read -r choice
    case $choice in
        1) manage_tool "Panel" "panel_logic" ;;
        2) manage_tool "Wings" "wings_logic" ;;
        5) manage_tool "Cloudflare" "cloudflare_logic" ;;
        11) # Ghost Combo logic...
            ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
