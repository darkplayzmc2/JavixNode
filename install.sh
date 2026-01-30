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
    echo -e "          ${Y1}🚀 JAVIX PRO: ULTIMATE OPERATIONAL EDITION${NC}"
    echo -e "          ${C1}developed by sk mohsin pasha${NC}"
    draw_sep
    echo -e "${Y1}     ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗"
    echo -e "     ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗"
    echo -e "     ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║"
    echo -e "██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║"
    echo -e "╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝"
    draw_sep
}

# --- Core Management Hub Wrapper ---
# This loop ensures no option reloads the main menu prematurely
manage_hub() {
    local tool_name=$1
    local logic_func=$2
    while true; do
        echo -e "\n  ${Y1}HUB: $tool_name${NC}"
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install/Execute"
        echo -e "  ${C1}3)${NC} Repair/Update"
        echo -e "  ${C1}4)${NC} Uninstall/Remove"
        echo -e "  ${C1}5)${NC} Back to Console"
        echo -e "  ${R1}6) Global Exit${NC}"
        echo -ne "\n  ${G1}Select Action > ${NC}"
        read -r sub_choice

        case $sub_choice in
            5) return ;;
            6) exit 0 ;;
            *) $logic_func "$sub_choice" ;;
        esac
        echo -ne "\n${Y1}Execution Finished. Press [Enter] to refresh HUB...${NC}"
        read -r
    done
}

# --- Specific Logic Modules ---

# [3] Resource Optimizer Logic
optimizer_logic() {
    case $1 in
        1) free -h ;;
        2) sync; echo 3 > /proc/sys/vm/drop_caches && echo "RAM Purged." ;;
        4) echo "Optimizer settings cannot be uninstalled." ;;
    esac
}

# [11] Ghost Combo Logic (Automated Stack)
ghost_logic() {
    case $1 in
        2)
            echo -ne "Domain: " && read fqdn
            echo -ne "Email: " && read email
            echo -ne "CF Token: " && read cf_token
            # Cloudflare
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            cloudflared service install "$cf_token"
            # Panel
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
            # Blueprint
            bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
            ;;
    esac
}

# --- Main Console ---
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
        1) manage_hub "Panel" "panel_logic" ;;
        3) manage_hub "Optimizer" "optimizer_logic" ;;
        11) manage_hub "Ghost Combo" "ghost_logic" ;;
        # ... Other mappings similarly follow
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
