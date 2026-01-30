#!/bin/bash

# --- JavixNodes Branding Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# --- Option 1: GitHub VPS Maker Logic ---
create_github_vps() {
    clear
    echo -e "${GOLD}╔════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║       GITHUB VPS CONFIGURATION         ║${NC}"
    echo -e "${GOLD}╚════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}📂 Creating VM data directory...${NC}"
    sleep 1

    # User Inputs
    read -p "  ▶ Enter VM Name: " vname
    read -p "  ▶ Enter RAM (MB): " vram
    read -p "  ▶ Enter CPU Cores: " vcpu
    read -p "  ▶ Enter OS Image (e.g. ubuntu:latest): " vimage

    echo -e "\n${GOLD}┌────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}RAM       :${NC} $vram MB"
    echo -e "  ${GREEN}CPU       :${NC} $vcpu cores"
    echo -e "  ${GREEN}NAME      :${NC} $vname"
    echo -e "  ${GREEN}IMAGE     :${NC} $vimage"
    echo -e "  ${GREEN}TYPE      :${NC} Javix GitHub Docker VPS"
    echo -e "${GOLD}└────────────────────────────────────────┘${NC}"

    echo -e "\n${CY32}🚀 Launching GitHub VPS...${NC}"
    
    # Check if docker is installed (Helpful for your Javix users)
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: docker command not found.${NC}"
        echo -e "Please run [2] IDX Tool Setup first."
    else
        docker run -it --name "$vname" --memory="${vram}m" --cpus="$vcpu" "$vimage" /bin/bash
    fi

    echo -e "\n${RED}▶▶ GitHub VPS session ended.${NC}"
    read -p "Press Enter to return to main menu..."
}

# --- Main Menu Function ---
main_menu() {
    clear
    echo -e "${GOLD}      ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗${NC}"
    echo -e "${GOLD}      ██║██╔══██╗██║   ██║██║╚██╗██╔╝${NC}"
    echo -e "${GOLD}      ██║███████║██║   ██║██║ ╚███╔╝ ${NC}"
    echo -e "${GOLD} ██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ${NC}"
    echo -e "${GOLD} ╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗${NC}"
    echo -e "${GOLD}  ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═╝${NC}"
    echo -e "            ${CYAN}NETWORK MANAGER${NC}"
    echo -e "         ${RED}Made by sk mohsin pasha${NC}"
    echo -e "${GOLD}══════════════════════════════════════════${NC}"
    echo -e "         DEVELOPMENT MANAGEMENT CONSOLE"
    echo -e "${GOLD}══════════════════════════════════════════${NC}"
    echo -e "\n${GOLD}┌────────────────────────────────────────┐${NC}"
    echo -e "│              ${GOLD}MAIN OPTIONS${NC}              │"
    echo -e "${GOLD}└────────────────────────────────────────┘${NC}"
    echo -e "  ${CYAN}[1]${NC} 🚀 GitHub VPS Maker"
    echo -e "  ${CYAN}[2]${NC} 🛠️  IDX Tool Setup"
    echo -e "  ${CYAN}[3]${NC} ⚡ IDX VPS Maker"
    echo -e "  ${CYAN}[4]${NC} 🌐 Real VPS (Any + KVM)"
    echo -e "  ${CYAN}[0]${NC} 👋 Exit"
    echo -e "\n${GOLD}══════════════════════════════════════════${NC}"
    echo -ne "${CYAN}[INPUT]${NC} Enter your choice: "
}

# --- Main Loop ---
while true; do
    main_menu
    read choice
    case $choice in
        1) create_github_vps ;;
        2) echo "Setup logic here..."; sleep 2 ;;
        3) echo "IDX VPS logic here..."; sleep 2 ;;
        4) echo "KVM logic here..."; sleep 2 ;;
        0) clear; echo "Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1 ;;
    esac
done
