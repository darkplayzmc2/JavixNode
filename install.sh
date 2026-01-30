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
    echo -e "          ${Y1}🚀 JAVIX PRO: AUTOMATED EDITION${NC}"
    echo -e "          ${C1}developed by sk mohsin pasha${NC}"
    draw_sep
    echo -e "${Y1}     ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗"
    echo -e "     ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗"
    echo -e "     ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║"
    echo -e "██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║"
    echo -e "╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝"
    draw_sep
}

# --- Management Hub Template with Global Exit ---
manage_tool() {
    local tool_name=$1
    echo -e "\n  ${Y1}HUB: $tool_name${NC}"
    echo -e "  ${C1}1)${NC} Check Status"
    echo -e "  ${C1}2)${NC} Install Fresh (Automated)"
    echo -e "  ${C1}3)${NC} Repair / Update"
    echo -e "  ${C1}4)${NC} Uninstall"
    echo -e "  ${C1}5)${NC} Back to Main Menu"
    echo -e "  ${R1}6) Exit Script${NC}"
    echo -ne "\n  ${G1}Select Action > ${NC}"
    read -r sub_choice
    
    # Handle Global Exit from Sub-Menu
    if [ "$sub_choice" == "6" ]; then
        echo -e "${R1}Terminating Javix Session...${NC}"
        exit 0
    fi
}

# --- Logic: Fully Automated Panel + Tunnel ---
ghost_combo() {
    echo -e "${Y1}👻 INITIALIZING PRE-FLIGHT DATA COLLECTION...${NC}"
    echo -ne "${C1}Enter Domain (FQDN): ${NC}" && read -r fqdn
    echo -ne "${C1}Enter Admin Email: ${NC}" && read -r admin_email
    echo -ne "${C1}Paste Cloudflare Token: ${NC}" && read -r cf_token
    
    draw_sep
    # 1. Cloudflare First
    echo -e "${G1}[1/3] Deploying Cloudflare Tunnel...${NC}"
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
    dpkg -i cf.deb && rm cf.deb
    cloudflared service install "$cf_token"
    systemctl start cloudflared
    
    # 2. Automated Panel (Selections forced)
    echo -e "${G1}[2/3] Installing Panel (Silent Mode)...${NC}"
    bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
$fqdn
UTC
$admin_email
admin
admin
$(openssl rand -base64 12)
y
y
y
EOF

    # 3. Blueprint & Theme Engine
    echo -e "${G1}[3/3] Injecting Blueprint Framework...${NC}"
    bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
    
    echo -e "${Y1}✔ GHOST COMBO SUCCESSFUL.${NC}"
}

# --- Main Menu (15 Options) ---
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
        1) manage_tool "Panel";;
        5) manage_tool "Cloudflare";;
        9) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        10) echo -e "${C1}Enter Theme URL: ${NC}" && read url && bash <(curl -sL $url) ;;
        11) ghost_combo ;;
        0) echo -e "${R1}Exiting...${NC}"; exit 0 ;;
        *) sleep 1 ;;
    esac
done
