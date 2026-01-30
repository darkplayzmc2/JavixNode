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

# --- Module: Panel Hub (Option 1) ---
manage_panel() {
    while true; do
        echo -e "\n  ${Y1}HUB: Pterodactyl Panel${NC}"
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install Fresh (Automated)"
        echo -e "  ${C1}3)${NC} Repair / Update"
        echo -e "  ${C1}4)${NC} Uninstall"
        echo -e "  ${C1}5)${NC} Back to Main Menu"
        echo -e "  ${R1}6) Exit Script${NC}"
        echo -ne "\n  ${G1}Select Action > ${NC}"
        read -r sub_choice

        case $sub_choice in
            1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}✔ Installed${NC}" || echo -e "${R1}✘ Not Found${NC}" ;;
            2) 
                echo -ne "${C1}Enter Domain (FQDN): ${NC}" && read -r fqdn
                echo -ne "${C1}Enter Admin Email: ${NC}" && read -r admin_email
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
                ;;
            3) cd /var/www/pterodactyl && php artisan p:upgrade ;;
            4) rm -rf /var/www/pterodactyl && echo -e "${R1}Panel Purged.${NC}" ;;
            5) break ;; # Returns to Main Menu
            6) exit 0 ;;
            *) echo -e "${R1}Invalid choice${NC}" ;;
        esac
        echo -ne "\n${Y1}Task Finished. Press [Enter] to continue...${NC}"
        read -r
    done
}

# --- Module: Wings Hub (Option 2) ---
manage_wings() {
    while true; do
        echo -e "\n  ${Y1}HUB: Pterodactyl Wings${NC}"
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install Wings"
        echo -e "  ${C1}3)${NC} Repair / Update"
        echo -e "  ${C1}4)${NC} Uninstall"
        echo -e "  ${C1}5)${NC} Back to Main Menu"
        echo -e "  ${R1}6) Exit Script${NC}"
        echo -ne "\n  ${G1}Select Action > ${NC}"
        read -r sub_choice

        case $sub_choice in
            1) systemctl is-active --quiet wings && echo -e "${G1}✔ Wings Active${NC}" || echo -e "${R1}✘ Wings Inactive${NC}" ;;
            2) bash <(curl -s https://pterodactyl-installer.se) --install-wings ;;
            3) systemctl restart wings ;;
            4) systemctl stop wings && rm -rf /etc/pterodactyl /usr/local/bin/wings ;;
            5) break ;;
            6) exit 0 ;;
            *) echo -e "${R1}Invalid choice${NC}" ;;
        esac
        echo -ne "\n${Y1}Task Finished. Press [Enter] to continue...${NC}"
        read -r
    done
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
        1) manage_panel ;;
        2) manage_wings ;;
        11) # Call Ghost Combo logic here
            ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
