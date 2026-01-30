#!/bin/bash

# --- Color Profile ---
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

# --- Tool Logic ---

# [1] Panel Installation
install_panel() {
    echo -ne "\n  ${CYAN}[INPUT]${NC} Enter FQDN (e.g. panel.example.com): "
    read fqdn
    # Automated Pterodactyl Installation
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

# [2] Wings Installation 
install_wings() {
    echo -ne "\n  ${CYAN}[INPUT]${NC} Paste Configuration JSON from Panel: "
    read -r config_json
    mkdir -p /etc/pterodactyl
    echo "$config_json" > /etc/pterodactyl/config.yml
    # Install Wings binary
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
    chmod u+x /usr/local/bin/wings
    systemctl enable --now wings
    echo -e "${GREEN}✔ Wings is online.${NC}"
}

# [3] Uninstall Tools (Deep Clean)
uninstall_tools() {
    echo -e "${RED}⚠ Purging all Pterodactyl files...${NC}"
    systemctl stop wings 2>/dev/null
    rm -rf /var/www/pterodactyl /etc/pterodactyl /usr/local/bin/wings
    echo -e "${GREEN}✔ System cleaned.${NC}"
}

# [4] Blueprint+Theme+Extensions
install_blueprint() {
    echo -e "${CYAN}🚀 Installing Blueprint Framework...${NC}"
    bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
}

# [5] Cloudflare Setup (Zero Trust)
setup_cloudflare() {
    if ! command -v cloudflared &> /dev/null; then
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
        dpkg -i cf.deb && rm cf.deb
    fi
    echo -ne "  ${CYAN}[INPUT]${NC} Paste Tunnel Token or Full Command: "
    read cf_input
    if [[ $cf_input == *"cloudflared"* ]]; then eval $cf_input; else cloudflared service install $cf_input; fi
}

# [6] System Information
system_info() {
    if command -v neofetch &> /dev/null; then neofetch; else top -n 1 | head -n 20; fi
    read -p "Press Enter to return..."
}

# [7] Tailscale (install + up)
setup_tailscale() {
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    echo -e "${GREEN}✔ Tailscale IP: $(tailscale ip -4)${NC}"
}

# [8] Database Setup
setup_database() {
    apt update && apt install mariadb-server -y
    mysql_secure_installation
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
        3) uninstall_tools ;;
        4) install_blueprint ;;
        5) setup_cloudflare ;;
        6) system_info ;;
        7) setup_tailscale ;;
        8) setup_database ;;
        0) clear; exit 0 ;;
        *) echo -e "${RED}Invalid Option${NC}"; sleep 1 ;;
    esac
    echo -e "\n${GOLD}Task finished.${NC}"
    sleep 2
done
