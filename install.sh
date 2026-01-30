#!/bin/bash

# --- Color Profile (Jishnu Exact) ---
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

# --- Cloudflare Setup Logic ---
setup_cloudflare() {
    clear
    echo -e "${CYAN}🚀 Initializing Cloudflare Zero Trust Setup...${NC}"
    
    # 1. Download and Install Phase (Happens First)
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${GOLD}Downloading and installing cloudflared binary...${NC}"
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
        sudo dpkg -i cf.deb && rm cf.deb
        echo -e "${GREEN}✔ Download and Installation complete.${NC}"
    else
        echo -e "${GREEN}✔ cloudflared is already installed.${NC}"
    fi

    draw_line
    
    # 2. Prompt Phase (Comes after download)
    echo -e "🔑 ${CYAN}Paste Cloudflare Tunnel token${NC}"
    echo -e "${GOLD}(sirf token ya poora command – dono chalega)${NC}"
    echo -ne "> "
    read cf_input

    # 3. Execution Phase
    if [[ $cf_input == *"cloudflared"* ]]; then
        echo -e "${CYAN}Executing full installation command...${NC}"
        eval $cf_input
    else
        echo -e "${CYAN}Installing service using provided token...${NC}"
        sudo cloudflared service install "$cf_input"
    fi

    echo -e "\n${GREEN}✔ Cloudflare setup sequence finished.${NC}"
    read -p "Press Enter to return to menu..."
}

# --- Other Tool Stubs ---
install_panel() {
    echo -ne "\n  ${CYAN}[INPUT]${NC} Enter FQDN: "
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
        5) setup_cloudflare ;;
        0) clear; exit 0 ;;
        *) echo -e "${RED}Option not yet implemented or invalid.${NC}"; sleep 1 ;;
    esac
done
