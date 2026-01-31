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
    echo -e "          ${Y1}🚀 JAVIX PRO: VALIDATION EDITION${NC}"
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
manage_hub() {
    local tool_name=$1
    local logic_func=$2
    while true; do
        clear
        draw_sep
        echo -e "          ${Y1}JAVIX HUB: ${tool_name^^}${NC}"
        draw_sep
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install/Execute"
        echo -e "  ${C1}3)${NC} Repair/Update"
        echo -e "  ${C1}4)${NC} Uninstall/Remove"
        echo -e "  ${C1}5)${NC} Back to Main Console"
        echo -e "  ${R1}6) Global Exit${NC}"
        draw_sep
        echo -ne "  ${G1}Select Action > ${NC}"
        read -e sub_choice

        echo -e ""
        case $sub_choice in
            5) return ;;
            6) echo -e "${R1}Exiting...${NC}"; exit 0 ;;
            *) $logic_func "$sub_choice" ;;
        esac
        
        echo -ne "\n${Y1}Task Done. Press [Enter] to clean screen & refresh HUB...${NC}"
        read -e dummy
    done
}

# --- LOGIC MODULES ---

# 1. Panel (VALIDATED INPUTS)
panel_logic() {
    case $1 in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}✔ Panel Installed${NC}" || echo -e "${R1}✘ Panel Not Found${NC}" ;;
        2) 
            # --- DATA COLLECTION PHASE (With Validation) ---
            echo -e "${Y1}--- CONFIGURATION REQUIRED ---${NC}"
            
            # Loop until valid input is received
            while [[ -z "$fqdn" ]]; do
                echo -ne "${C1}Domain (FQDN): ${NC}"
                read -e fqdn
            done
            
            while [[ -z "$timezone" ]]; do
                echo -ne "${C1}Timezone (e.g., Asia/Kolkata): ${NC}"
                read -e timezone
            done

            while [[ -z "$email" ]]; do
                echo -ne "${C1}Email (Admin & Let's Encrypt): ${NC}"
                read -e email
            done

            while [[ -z "$firstname" ]]; do
                echo -ne "${C1}First Name: ${NC}"
                read -e firstname
            done

            while [[ -z "$lastname" ]]; do
                echo -ne "${C1}Last Name: ${NC}"
                read -e lastname
            done

            while [[ -z "$admin_pass" ]]; do
                echo -ne "${C1}Admin Password: ${NC}"
                read -e admin_pass
            done
            
            # Generate DB Password silently
            db_pass=$(openssl rand -base64 12)
            
            # CONFIRMATION DISPLAY
            echo -e "\n${Y1}--- REVIEW DATA ---${NC}"
            echo -e "Domain: ${G1}$fqdn${NC}"
            echo -e "Email: ${G1}$email${NC}"
            echo -e "Name: ${G1}$firstname $lastname${NC}"
            echo -e "Timezone: ${G1}$timezone${NC}"
            echo -e "-------------------"
            read -p "Press [Enter] to start installation..."

            echo -e "\n${G1}Injecting Configuration into Installer...${NC}"
            
            # --- EXECUTION PHASE ---
            # Added the final 'y' for the "Initial configuration completed" prompt
            bash <(curl -s https://pterodactyl-installer.se) <<EOF
0
panel
pterodactyl
$db_pass
$timezone
$email
$email
admin
$firstname
$lastname
$admin_pass
$fqdn
y
y
y
y
EOF
            ;;
        4) rm -rf /var/www/pterodactyl && echo -e "${R1}Panel Deleted.${NC}" ;;
    esac
}

# 2. Wings
wings_logic() {
    case $1 in
        1) systemctl is-active wings && echo -e "${G1}✔ Wings Active${NC}" || echo -e "${R1}✘ Wings Inactive${NC}" ;;
        2) bash <(curl -s https://pterodactyl-installer.se) --install-wings ;;
        4) systemctl stop wings && rm -rf /etc/pterodactyl /usr/local/bin/wings ;;
    esac
}

# 3. Optimizer
optimizer_logic() {
    case $1 in
        1) free -h ;;
        2) sync; echo 3 > /proc/sys/vm/drop_caches; echo -e "${G1}✔ RAM Purged.${NC}" ;;
    esac
}

# 4. Backups
backup_logic() {
    case $1 in
        1) crontab -l | grep "javix_backup" ;;
        2) (crontab -l ; echo "0 3 * * * tar -zcvf /root/javix_backup.tar.gz /var/www/pterodactyl") | crontab - ;;
        4) crontab -l | grep -v "javix_backup" | crontab - ;;
    esac
}

# 5. Cloudflare
cf_logic() {
    case $1 in
        1) systemctl is-active cloudflared ;;
        2) 
            echo -e "${C1}Downloading Cloudflare binaries...${NC}"
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            
            echo -e "\n${Y1}Paste Cloudflare Token OR Command:${NC}"
            echo -ne "> "
            read -e raw_input
            
            token=$(echo "$raw_input" | grep -oE "ey[A-Za-z0-9\-_=]+" | head -n 1)
            [ -z "$token" ] && token=$raw_input
            
            echo -e "${C1}Installing Service...${NC}"
            sudo cloudflared service install "$token"
            ;;
        4) cloudflared service uninstall ;;
    esac
}

# 6. Tailscale
ts_logic() {
    case $1 in
        1) tailscale status ;;
        2) 
            echo -e "${C1}Downloading Tailscale packages...${NC}"
            curl -fsSL https://tailscale.com/install.sh | sh
            if [ -f "/usr/bin/tailscale" ]; then TS_BIN="/usr/bin/tailscale"; else TS_BIN="tailscale"; fi
            
            echo -e "\n${Y1}--- AUTHENTICATION REQUIRED ---${NC}"
            echo -e "${G1}If a link appears below, COPY IT to your browser.${NC}"
            echo -e "${Y1}-------------------------------${NC}\n"
            sleep 2
            sudo $TS_BIN up
            ;;
        4) tailscale down && apt remove tailscale -y ;;
    esac
}

# 7. Security
sec_logic() {
    case $1 in
        1) ufw status ;;
        2) ufw allow 22,80,443,8080/tcp && ufw enable && apt install fail2ban -y ;;
        4) ufw disable ;;
    esac
}

# 8. Database
db_logic() {
    case $1 in
        1) systemctl is-active mariadb ;;
        2) apt update && apt install mariadb-server -y && mysql_secure_installation ;;
    esac
}

# 9. Blueprint
bp_logic() {
    case $1 in
        2) bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh) ;;
    esac
}

# 10. Themes
theme_logic() {
    case $1 in
        2) echo -ne "${C1}Theme URL: ${NC}" && read -e url && bash <(curl -sL $url) ;;
    esac
}

# 11. GHOST COMBO (Validated)
ghost_logic() {
    case $1 in
        2)
            while [[ -z "$fqdn" ]]; do echo -ne "${C1}Domain: ${NC}"; read -e fqdn; done
            while [[ -z "$timezone" ]]; do echo -ne "${C1}Timezone: ${NC}"; read -e timezone; done
            while [[ -z "$email" ]]; do echo -ne "${C1}Email: ${NC}"; read -e email; done
            while [[ -z "$firstname" ]]; do echo -ne "${C1}First Name: ${NC}"; read -e firstname; done
            while [[ -z "$lastname" ]]; do echo -ne "${C1}Last Name: ${NC}"; read -e lastname; done
            while [[ -z "$admin_pass" ]]; do echo -ne "${C1}Admin Password: ${NC}"; read -e admin_pass; done
            while [[ -z "$cf_token" ]]; do echo -ne "${C1}CF Token: ${NC}"; read -e cf_token; done
            
            clean_token=$(echo "$cf_token" | grep -oE "ey[A-Za-z0-9\-_=]+" | head -n 1)
            [ -z "$clean_token" ] && clean_token=$cf_token

            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            cloudflared service install "$clean_token"

            db_pass=$(openssl rand -base64 12)
            bash <(curl -s https://pterodactyl-installer.se) <<EOF
0
panel
pterodactyl
$db_pass
$timezone
$email
$email
admin
$firstname
$lastname
$admin_pass
$fqdn
y
y
y
y
EOF
            bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
            ;;
    esac
}

# 12. SSL
ssl_logic() {
    case $1 in
        2) apt install certbot -y && echo -ne "Domain: " && read -e d && certbot certonly --standalone -d $d ;;
    esac
}

# 13. Node.js
node_logic() {
    case $1 in
        1) node -v ;;
        2) curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && apt-get install -y nodejs ;;
    esac
}

# 14. Discord Bots
bot_logic() {
    case $1 in
        2) apt install python3 python3-pip -y && pip3 install discord.py && echo -e "${G1}Python Environment Ready${NC}" ;;
    esac
}

# 15. Logs
log_logic() {
    case $1 in
        2) tail -f /var/www/pterodactyl/storage/logs/laravel-$(date +%F).log ;;
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
    
    read -e choice
    case $choice in
        1) manage_hub "Panel" "panel_logic" ;;
        2) manage_hub "Wings" "wings_logic" ;;
        3) manage_hub "Optimizer" "optimizer_logic" ;;
        4) manage_hub "Backups" "backup_logic" ;;
        5) manage_hub "Cloudflare" "cf_logic" ;;
        6) manage_hub "Tailscale" "ts_logic" ;;
        7) manage_hub "Security" "sec_logic" ;;
        8) manage_hub "Databases" "db_logic" ;;
        9) manage_hub "Blueprint" "bp_logic" ;;
        10) manage_hub "Themes" "theme_logic" ;;
        11) manage_hub "Ghost Combo" "ghost_logic" ;;
        12) manage_hub "SSL" "ssl_logic" ;;
        13) manage_hub "Node.js" "node_logic" ;;
        14) manage_hub "Discord Bots" "bot_logic" ;;
        15) manage_hub "System Logs" "log_logic" ;;
        0) exit 0 ;;
        *) sleep 1 ;;
    esac
done
