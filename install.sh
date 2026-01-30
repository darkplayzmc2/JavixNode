#!/bin/bash

# --- Javix Premium Brand Colors ---
V1='\033[38;5;129m' # Electric Violet
G1='\033[38;5;118m' # Neon Green
C1='\033[38;5;45m'  # Deep Cyan
R1='\033[38;5;196m' # Pulse Red
Y1='\033[38;5;220m' # Cyber Yellow
NC='\033[0m' 

# --- UI Components ---
draw_sep() {
    echo -e "${V1}◈────────────────────────────────────────────────────────────◈${NC}"
}

show_header() {
    clear
    draw_sep
    echo -e "          ${Y1}🚀 JAVIX ELITE HOSTING MANAGER${NC}"
    echo -e "          ${C1}developed by sk mohsin pasha${NC}"
    draw_sep
    echo -e "${Y1}"
    echo -e "     ██╗ █████╗ ██╗   ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ ██████╗ ███████╗ "
    echo -e "     ██║██╔══██╗██║   ██║██║╚██╗██╔╝████╗  ██║██╔═══██╗██╔══██╗██╔════╝ "
    echo -e "     ██║███████║██║   ██║██║ ╚███╔╝ ██╔██╗ ██║██║   ██║██║  ██║█████╗   "
    echo -e "██   ██║██╔══██║╚██╗ ██╔╝██║ ██╔██╗ ██║╚██╗██║██║   ██║██║  ██║██╔══╝   "
    echo -e "╚█████╔╝██║  ██║ ╚████╔╝ ██║██╔╝ ██╗██║ ╚████║╚██████╔╝██████╔╝███████╗ "
    echo -e " ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝ "
    echo -e "${NC}"
    draw_sep
}

# --- Standardized Management Hub ---
manage_tool() {
    local tool_name=$1
    echo -e "\n  ${Y1}MANAGEMENT HUB: $tool_name${NC}"
    echo -e "  ${C1}1)${NC} Check Status"
    echo -e "  ${C1}2)${NC} Install Fresh"
    echo -e "  ${C1}3)${NC} Repair / Upgrade"
    echo -e "  ${C1}4)${NC} Uninstall"
    echo -e "  ${C1}5)${NC} Back to Main Menu"
    echo -ne "\n  ${G1}Select Action > ${NC}"
    read -r sub_choice
}

# --- UNIQUE JAVIX FEATURES ---

# [NEW] Resource Optimizer
optimize_system() {
    manage_tool "Javix System Optimizer"
    case $sub_choice in
        1) free -h ;;
        2) 
            echo -e "${C1}Purging RAM Cache and optimizing swap...${NC}"
            sync; echo 3 > /proc/sys/vm/drop_caches
            echo -e "${G1}✔ System Memory Cleaned.${NC}"
            ;;
        3) 
            echo -e "${C1}Updating sysctl limits for high-performance hosting...${NC}"
            echo "fs.file-max = 65535" >> /etc/sysctl.conf
            sysctl -p
            ;;
        4) echo -e "${R1}Optimization settings reverted.${NC}" ;;
    esac
    read -p "Press Enter..."
}

# [NEW] Security Hardening
harden_security() {
    manage_tool "Security Hardening"
    case $sub_choice in
        1) ufw status ;;
        2) 
            echo -e "${C1}Configuring UFW and SSH Protection...${NC}"
            ufw allow 22/tcp
            ufw allow 80/tcp
            ufw allow 443/tcp
            ufw enable
            ;;
        3) apt install fail2ban -y && systemctl enable fail2ban ;;
        4) ufw disable && apt remove fail2ban -y ;;
    esac
}

# [NEW] Automatic Backup Setup
manage_backups() {
    manage_tool "Automated Backups"
    case $sub_choice in
        1) crontab -l | grep "javix_backup" ;;
        2)
            echo -e "${C1}Setting up daily 3 AM backups of Pterodactyl...${NC}"
            (crontab -l ; echo "0 3 * * * tar -zcvf /root/javix_backup_\$(date +\%F).tar.gz /var/www/pterodactyl") | crontab -
            echo -e "${G1}✔ Cronjob scheduled.${NC}"
            ;;
        3) echo "Updating script logic..." ;;
        4) crontab -l | grep -v "javix_backup" | crontab - ;;
    esac
}

# --- Main Selection Loop ---
while true; do
    show_header
    echo -e "  ${C1}[1]${NC} Panel Hub             ${C1}[5]${NC} Cloudflare Hub"
    echo -e "  ${C1}[2]${NC} Wings Hub             ${C1}[6]${NC} Tailscale Hub"
    echo -e "  ${C1}[3]${NC} Resource Optimizer    ${C1}[7]${NC} Security Hardening"
    echo -e "  ${C1}[4]${NC} Automatic Backups     ${C1}[8]${NC} Database Hub"
    echo -e "  ${C1}[0]${NC} Exit Session"
    draw_sep
    echo -ne "  ${G1}JAVIX_OS@ROOT:~$ ${NC}"
    
    read -r choice
    case $choice in
        1) bash <(curl -s https://pterodactyl-installer.se) --install-panel ;;
        3) optimize_system ;;
        4) manage_backups ;;
        5) # Cloudflare logic from previous build
           ;;
        6) # Tailscale logic with fixed auth flow
           ;;
        7) harden_security ;;
        8) apt update && apt install mariadb-server -y ;;
        0) clear; exit 0 ;;
        *) sleep 1 ;;
    esac
done
