#!/bin/bash

# --- JavixNodes Branding & Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

# --- Option 2: IDX Tool Setup (The Working Version) ---
idx_tool_setup() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║            IDX SYSTEM OPTIMIZATION             ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}[STEP 1] Checking Core Systems...${NC}"
    sleep 1

    # Check for Docker (Vital for your VPS Maker)
    if ! command -v docker &> /dev/null; then
        echo -e "[${RED}×${NC}] Docker: Not Found"
        echo -e "${RED}!! Action Required: !!${NC}"
        echo -e "You must add the following to your ${GOLD}.idx/devnix.nix${NC} file:"
        echo -e "${CYAN}--------------------------------------"
        echo -e "packages = [ pkgs.docker ];"
        echo -e "services.docker.enable = true;"
        echo -e "--------------------------------------${NC}"
    else
        echo -e "[${GREEN}✓${NC}] Docker: Active"
    fi

    echo -e "\n${CYAN}[STEP 2] Optimizing Permissions...${NC}"
    # Automatically makes all scripts in your JavixNode project executable
    chmod +x *.sh 2>/dev/null
    echo -e "[${GREEN}✓${NC}] Shell permissions updated for JavixNode scripts."

    echo -e "\n${CYAN}[STEP 3] Environment Variables...${NC}"
    # Creates a local marker to prevent double-setup
    mkdir -p ~/.javix && touch ~/.javix/setup_done
    echo -e "[${GREEN}✓${NC}] Javix local environment initialized."

    echo -e "\n${GREEN}Setup Complete! Re-run the script after updating devnix.nix.${NC}"
    read -p "Press Enter to return to main menu..."
}

# --- Option 1: GitHub VPS Maker ---
create_github_vps() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║           GITHUB VPS CONFIGURATION             ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    read -p "  ▶ Enter VM Name: " vname
    read -p "  ▶ Enter OS Image: " vimage
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is missing. Run Option [2] first!${NC}"
    else
        docker run -it --name "$vname" "$vimage" /bin/bash
    fi
    read -p "Press Enter to return..."
}

# --- Main UI ---
main_menu() {
    clear
    echo -e "${GOLD}      :::::::::::     :::     :::     ::: ::::::::::: :::    ::: ${NC}"
    echo -e "${GOLD}         :+:       :+: :+:   :+:     :+:     :+:     :+:    :+:  ${NC}"
    echo -e "${GOLD}        +:+      +:+   +:+  +:+     +:+     +:+      +:+  +:+    ${NC}"
    echo -e "${GOLD}       +#+     +#++:++#++: +#+     +:+     +#+       +#++:+      ${NC}"
    echo -e "${GOLD}      +#+     +#+     +#+  +#+   +#+      +#+      +#+  +#+      ${NC}"
    echo -e "${GOLD}     #+#     #+#     #+#   #+# #+#       #+#     #+#    #+#      ${NC}"
    echo -e "${GOLD} #######     ###     ###    #####    ########### ###    ###      ${NC}"
    echo -e "            ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "\n  ${CYAN}[1]${NC} 🚀 GitHub VPS Maker"
    echo -e "  ${CYAN}[2]${NC} 🔧 IDX Tool Setup"
    echo -e "  ${CYAN}[0]${NC} 👋 Exit"
    echo -ne "\n${CYAN}[INPUT]${NC} Selection: "
}

while true; do
    main_menu
    read choice
    case $choice in
        1) create_github_vps ;;
        2) idx_tool_setup ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
