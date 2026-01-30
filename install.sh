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

# --- Functional Logic Modules ---

# [1] Panel Installation (Fixed Silent Install)
install_panel() {
    echo -ne "\n  ${CYAN}[INPUT]${NC} Enter FQDN (e.g. panel.javixnode.fun): "
    read fqdn
    # Ensure dependencies are met before running
    apt update && apt install -y curl tar unzip
    # Execute installer with automated inputs
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
}

# [2] Wings Installation (Fixed Binary & Service)
install_wings() {
    echo -ne "\n  ${CYAN}[INPUT]${NC} Paste Panel Configuration JSON: "
    read -r config_json
    
    # 1. Create directory structure
    mkdir -p /etc/pterodactyl
    echo "$config_json" > /etc/pterodactyl/config.yml
    
    # 2. Download and set permissions (This was likely the failing step)
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
    chmod u+x /usr/local/bin/wings
    
    # 3. Enable and Start service
    systemctl enable --now wings
    echo -e "${GREEN}✔ Wings service started and linked.${NC}"
}

# [5] Cloudflare Setup (Fixed Token Parsing)
setup_cloudflare() {
    if ! command -v cloudflared &> /dev/null; then
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
        dpkg -i cf.deb && rm cf.deb
    fi
    echo -ne "  ${CYAN}[INPUT]${NC} Paste Token or Full Install Command: "
    read cf_input
    # Detect if full command or just token was pasted
    if [[ $cf_input == *"cloudflared"* ]]; then 
        eval $cf_input 
    else 
        cloudflared service install $cf_input 
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
        1) install_panel ;;
        2) install_wings ;;
        3) rm -rf /var/www/pterodactyl /etc/pterodactyl /usr/local/bin/wings; echo "Purged."; sleep 1 ;;
        4) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
        5) setup_cloudflare ;;
        6) neofetch || top -n 1 | head -n 20; read -p "Enter to return..." ;;
        7) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
