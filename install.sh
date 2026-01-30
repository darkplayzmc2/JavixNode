#!/bin/bash

# --- JavixNodes Branding & Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- Option 1: GitHub VPS Maker ---
create_github_vps() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║           GITHUB VPS CONFIGURATION             ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}📂 Initializing VM Environment...${NC}"
    sleep 1

    read -p "  ▶ Enter VM Name: " vname
    read -p "  ▶ Enter RAM (MB): " vram
    read -p "  ▶ Enter CPU Cores: " vcpu
    read -p "  ▶ Enter OS Image (e.g. debian:latest): " vimage

    echo -e "\n${GOLD}┌────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}NAME      :${NC} $vname"
    echo -e "  ${GREEN}SPECS     :${NC} $vram MB RAM / $vcpu Cores"
    echo -e "  ${GREEN}IMAGE     :${NC} $vimage"
    echo -e "  ${GREEN}PROVIDER  :${NC} JavixNodes Virtualization"
    echo -e "${GOLD}└────────────────────────────────────────────────┘${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: docker not found. Run Option [2] first!${NC}"
    else
        echo -e "${CYAN}🚀 Launching isolated container...${NC}"
        docker run -it --name "$vname" --memory="${vram}m" --cpus="$vcpu" "$vimage" /bin/bash
    fi
    read -p "Press Enter to return..."
}

# --- Option 2: IDX Tool Setup (The "Better" Version) ---
idx_tool_setup() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║            IDX SYSTEM OPTIMIZATION             ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Cleaning up old files...${NC}"
    
    # Check for IDX config directory
    if [ -d "~/.idx" ]; then
        echo -e "${GOLD}⚠ IDX Tool already setup - skipping. Location: ~/.idx${NC}"
    else
        echo -e "${GREEN}Creating Javix environment structure...${NC}"
        mkdir -p ~/.idx
    fi

    echo -e "\n${CYAN}Checking Dependencies...${NC}"
    
    # Check for Docker
    if command -v docker &> /dev/null; then
        echo -e "[${GREEN}✓${NC}] Docker System: Active"
    else
        echo -e "[${RED}×${NC}] Docker System: Missing"
        echo -e "    ${RED}Action Required:${NC} Enable 'services.docker.enable = true' in devnix.nix"
    fi

    # Check for Node (Common for your Discord Bots)
    if command -v node &> /dev/null; then
        echo -e "[${GREEN}✓${NC}] Node.js: $(node -v)"
    fi

    echo -e "\n${GREEN}Success: Environment optimized for JavixNode.${NC}"
    read -p "Press Enter to return to main menu..."
}

# --- Main UI Design ---
main_menu() {
    clear
    echo -e "${GOLD}      :::::::::::     :::     :::     ::: ::::::::::: :::    ::: ${NC}"
    echo -e "${GOLD}         :+:       :+: :+:   :+:     :+:     :+:     :+:    :+:  ${NC}"
    echo -e "${GOLD}        +:+      +:+   +:+  +:+     +:+     +:+      +:+  +:+    ${NC}"
    echo -e "${GOLD}       +#+     +#++:++#++: +#+     +:+     +#+       +#++:+      ${NC}"
    echo -e "${GOLD}      +#+     +#+     +#+  +#+   +#+      +#+      +#+  +#+      ${NC}"
    echo -e "${GOLD}     #+#     #+#     #+#   #+# #+#       #+#     #+#    #+#      ${NC}"
    echo -e "${GOLD} #######     ###     ###    #####    ########### ###    ###      ${NC}"
    echo -e "         ${CYAN}⚡ JAVIXNODES DEVELOPMENT CONSOLE ⚡${NC}"
    echo -e "            ${RED}Developer: sk mohsin pasha${NC}"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "               MANAGEMENT INTERFACE v2.0"
    echo -e "${GOLD}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "\n${GOLD}  ┌──────────────────────────────────────────────┐${NC}"
    echo -e "  │                 ${GOLD}MAIN OPTIONS${NC}                 │"
    echo -e "  ${GOLD}├──────────────────────────────────────────────┤${NC}"
    echo -e "  │  ${CYAN}[1]${NC} 🚀 GitHub VPS Maker                      │"
    echo -e "  │  ${CYAN}[2]${NC} 🔧 IDX Tool Setup                        │"
    echo -e "  │  ${CYAN}[3]${NC} ⚡ IDX VPS Maker                         │"
    echo -e "  │  ${CYAN}[4]${NC} 🌐 Real VPS (Any + KVM)                  │"
    echo -e "  │  ${CYAN}[0]${NC} 👋 Exit                                  │"
    echo -e "  ${GOLD}└──────────────────────────────────────────────┘${NC}"
    echo -ne "\n${CYAN}[INPUT]${NC} Selection: "
}

# --- Main Logic ---
while true; do
    main_menu
    read choice
    case $choice in
        1) create_github_vps ;;
        2) idx_tool_setup ;;
        3) echo -e "${BLUE}Coming soon to JavixNode...${NC}"; sleep 2 ;;
        4) echo -e "${BLUE}Checking KVM availability...${NC}"; sleep 2 ;;
        0) clear; echo "JavixNode session closed."; exit 0 ;;
        *) echo -e "${RED}Invalid Selection!${NC}"; sleep 1 ;;
    esac
done
