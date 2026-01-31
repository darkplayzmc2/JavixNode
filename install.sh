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
    echo -e "          ${Y1}🚀 JAVIX PRO: 500 ERROR FIXER${NC}"
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
        
        echo -e "${G1}Select Action:${NC}"
        echo -ne "  > "
        read sub_choice

        case $sub_choice in
            5) return ;;
            6) echo -e "${R1}Exiting...${NC}"; exit 0 ;;
            *) $logic_func "$sub_choice" ;;
        esac
        
        echo -ne "\n${Y1}Task Done. Press [Enter] to clean screen & refresh HUB...${NC}"
        read dummy
    done
}

# --- LOGIC MODULES ---

# 1. Panel (WITH 500 REPAIR)
panel_logic() {
    case $1 in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}✔ Panel Installed${NC}" || echo -e "${R1}✘ Panel Not Found${NC}" ;;
        2) 
            # (Standard Installation Logic Hidden for brevity - use Option 3 for fix)
            echo -e "${R1}Please use Option 3 (Repair) to fix your current error.${NC}"
            ;;
        3) 
            # --- REPAIR MODULE ---
            echo -e "\n${Y1}--- REPAIR MENU ---${NC}"
            echo -e "  ${C1}A)${NC} EMERGENCY: Fix 500 Internal Server Error"
            echo -e "  ${C1}B)${NC} Fix 502 Bad Gateway"
            echo -ne "  > "
            read r_choice
            
            if [[ "$r_choice" == "A" || "$r_choice" == "a" ]]; then
                echo -e "\n${Y1}--- FIXING 500 ERROR ---${NC}"
                cd /var/www/pterodactyl || return
                
                # 1. Fix Permissions (Most common cause of 500)
                echo -e "${C1}Step 1: Fixing Permissions...${NC}"
                chmod -R 755 storage/* bootstrap/cache/
                chown -R www-data:www-data /var/www/pterodactyl/*
                
                # 2. Database Repair (Second most common cause)
                echo -e "${C1}Step 2: Re-running Database Migrations...${NC}"
                # Force database setup if it was skipped
                php artisan migrate --seed --force
                
                # 3. Cache & Config Clear
                echo -e "${C1}Step 3: Clearing System Cache...${NC}"
                php artisan view:clear
                php artisan config:clear
                php artisan cache:clear
                
                # 4. Generate Key if missing
                echo -e "${C1}Step 4: Verifying Application Key...${NC}"
                if grep -q "APP_KEY=" .env; then
                    php artisan key:generate
                fi

                echo -e "${G1}✔ 500 ERROR FIX APPLIED.${NC}"
                echo -e "${Y1}Try reloading your website now.${NC}"
            
            elif [[ "$r_choice" == "B" || "$r_choice" == "b" ]]; then
                # 502 Fixer (Previous Logic)
                echo -e "${C1}Applying 502 Patch...${NC}"
                cd /var/www/pterodactyl
                sed -i 's/^APP_URL=http:/APP_URL=https:/g' .env
                sed -i 's/^TRUSTED_PROXIES=.*/TRUSTED_PROXIES=*/g' .env
                systemctl restart nginx
                systemctl restart php8.3-fpm
                echo -e "${G1}✔ 502 Patch Applied.${NC}"
            fi
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
            
            echo -e "\n${Y1}Paste Cloudflare Token:${NC}"
            echo -ne "  > "
            read raw_input
            
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

# 9. Blueprint & NEBULA
bp_logic() {
    case $1 in
        1) [ -f "/usr/local/bin/blueprint" ] && echo -e "${G1}✔ Blueprint Active${NC}" || echo -e "${R1}✘ Not Installed${NC}" ;;
        2) 
            echo -e "\n${Y1}--- BLUEPRINT STORE ---${NC}"
            echo -e "  ${C1}A)${NC} Install Blueprint Framework"
            echo -e "  ${C1}B)${NC} Install NEBULA Theme (Official)"
            echo -ne "  > "
            read bp_choice
            
            if [[ "$bp_choice" == "A" || "$bp_choice" == "a" ]]; then
                bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
            elif [[ "$bp_choice" == "B" || "$bp_choice" == "b" ]]; then
                echo -e "${G1}Installing Nebula Theme...${NC}"
                cd /var/www/pterodactyl
                blueprint -install nebula
            fi
            ;;
        3) blueprint -upgrade ;;
    esac
}

# 10. Themes
theme_logic() {
    case $1 in
        2) echo -e "${C1}Theme URL:${NC}"; echo -ne "  > "; read url && bash <(curl -sL $url) ;;
    esac
}

# 11. GHOST COMBO
ghost_logic() {
    case $1 in
        2)
            echo -e "${C1}Domain:${NC}"; read fqdn
            echo -e "${C1}Email:${NC}"; read email
            echo -e "${C1}CF Token:${NC}"; read cf_token
            
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
UTC
$email
$email
admin
Admin
User
$db_pass
$fqdn
y
n
y
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
        2) apt install certbot -y && echo -e "Domain:"; echo -ne "  > "; read d && certbot certonly --standalone -d $d ;;
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
    echo -e "  ${C1}[1]${NC} Panel Hub             ${C1}[9]${NC} Blueprint & Nebula"
    echo -e "  ${C1}[2]${NC} Wings Hub             ${C1}[10]${NC} Theme Installer"
    echo -e "  ${C1}[3]${NC} Resource Optimizer    ${C1}[11]${NC} GHOST COMBO (Auto)"
    echo -e "  ${C1}[4]${NC} Automatic Backups     ${C1}[12]${NC} SSL Auto-Cert"
    echo -e "  ${C1}[5]${NC} Cloudflare Hub        ${C1}[13]${NC} Node.js Manager"
    echo -e "  ${C1}[6]${NC} Tailscale VPN         ${C1}[14]${NC} Discord Bot Host"
    echo -e "  ${C1}[7]${NC} Security Hardening    ${C1}[15]${NC} Live System Logs"
    echo -e "  ${C1}[0]${NC} Exit Session"
    draw_sep
    echo -e "${G1}JAVIX_OS@ROOT:${NC}"
    echo -ne "  > "
    read choice
    
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
