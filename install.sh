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
    echo -e "          ${Y1}🚀 JAVIX PRO: FINAL STABLE EDITION${NC}"
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
        echo -e "\n  ${Y1}HUB: $tool_name${NC}"
        echo -e "  ${C1}1)${NC} Check Status"
        echo -e "  ${C1}2)${NC} Install/Execute"
        echo -e "  ${C1}3)${NC} Repair/Update"
        echo -e "  ${C1}4)${NC} Uninstall/Remove"
        echo -e "  ${C1}5)${NC} Back to Main Console"
        echo -e "  ${R1}6) Global Exit${NC}"
        echo -ne "\n  ${G1}Select Action > ${NC}"
        read -r sub_choice

        case $sub_choice in
            5) return ;;
            6) echo -e "${R1}Exiting...${NC}"; exit 0 ;;
            *) $logic_func "$sub_choice" ;;
        esac
        echo -ne "\n${Y1}Task Done. Press [Enter] to refresh HUB...${NC}"
        read -r
    done
}

# --- ALL 15 LOGIC MODULES ---

# 1. Panel
panel_logic() {
    case $1 in
        1) [ -d "/var/www/pterodactyl" ] && echo -e "${G1}Installed${NC}" || echo -e "${R1}Not Found${NC}" ;;
        2) 
            echo -ne "${C1}Domain: ${NC}" && read fqdn
            echo -ne "${C1}Email: ${NC}" && read email
            bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
$fqdn
UTC
$email
admin
admin
$(openssl rand -base64 12)
y
y
y
EOF
            ;;
        4) rm -rf /var/www/pterodactyl ;;
    esac
}

# 2. Wings
wings_logic() {
    case $1 in
        1) systemctl is-active wings && echo -e "${G1}Active${NC}" || echo -e "${R1}Inactive${NC}" ;;
        2) bash <(curl -s https://pterodactyl-installer.se) --install-wings ;;
        4) systemctl stop wings && rm -rf /etc/pterodactyl /usr/local/bin/wings ;;
    esac
}

# 3. Optimizer
optimizer_logic() {
    case $1 in
        1) free -h ;;
        2) sync; echo 3 > /proc/sys/vm/drop_caches; echo -e "${G1}RAM Purged.${NC}" ;;
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
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            echo -ne "${C1}Token: ${NC}" && read token
            cloudflared service install "$token"
            ;;
        4) cloudflared service uninstall ;;
    esac
}

# 6. Tailscale
ts_logic() {
    case $1 in
        1) tailscale status ;;
        2) curl -fsSL https://tailscale.com/install.sh | sh && tailscale up ;;
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
        2) echo -ne "${C1}Theme URL: ${NC}" && read url && bash <(curl -sL $url) ;;
    esac
}

# 11. GHOST COMBO (Automated)
ghost_logic() {
    case $1 in
        2)
            echo -ne "${C1}Domain: ${NC}" && read fqdn
            echo -ne "${C1}Email: ${NC}" && read email
            echo -ne "${C1}CF Token: ${NC}" && read cf_token
            # 1. CF
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cf.deb
            dpkg -i cf.deb && rm cf.deb
            cloudflared service install "$cf_token"
            # 2. Panel
            bash <(curl -s https://pterodactyl-installer.se) --install-panel <<EOF
1
$fqdn
UTC
$email
admin
admin
$(openssl rand -base64 12)
y
y
y
EOF
            # 3. Blueprint
            bash <(curl -L https://github.com/teamblueprint/main/releases/latest/download/blueprint.sh)
            ;;
    esac
}

# 12. SSL
ssl_logic() {
    case $1 in
        2) apt install certbot -y && echo -ne "Domain: " && read d && certbot certonly --standalone -d $d ;;
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

# --- Main Console (15 Hard-Mapped Options) ---
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
