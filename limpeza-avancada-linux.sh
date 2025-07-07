#!/bin/bash

# ===================================================================================
# =                        Advanced System Cleaner for Linux                        =
# ===================================================================================
# = Description: A robust and safe script to clean and optimize Linux systems.      =
# = Author: Gemini AI                                                               =
# = Version: 1.0                                                                    =
# ===================================================================================

# --- Initial Setup ---
set -o pipefail
export LC_ALL=C # Ensure consistent command output for parsing

# --- Script Configuration ---
LOG_FILE="/var/log/limpeza-avancada-$(date +%Y-%m-%d).log"
SUDO_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

# --- Flags and Modes ---
DRY_RUN=0
CONFIRM_EACH=0
SECURE_MODE=0

# --- Internationalization (i18n) ---
LANG_PREF=$(echo "$LANG" | cut -d'_' -f1)

if [[ "$LANG_PREF" == "pt" ]]; then
    # Portuguese Messages
    MSG_ROOT_REQUIRED="Erro: Este script precisa ser executado como root (sudo)."
    MSG_DRY_RUN_MODE="*** MODO SIMULAÇÃO (DRY-RUN) ATIVADO. NENHUMA ALTERAÇÃO SERÁ FEITA. ***"
    MSG_CONFIRM_PROMPT="Você confirma a execução desta etapa? (s/N): "
    MSG_DISTRO_DETECTED="Distribuição detectada:"
    MSG_CLEANING="Limpando"
    MSG_CACHE="cache de pacotes"
    MSG_TEMP_FILES="arquivos temporários"
    MSG_OLD_LOGS="logs antigos do journal"
    MSG_ORPHAN_PACKAGES="pacotes órfãos"
    MSG_BROWSER_CACHE="cache de navegadores"
    MSG_FLATPAK="pacotes Flatpak não utilizados"
    MSG_SNAP="versões antigas de snaps"
    MSG_SUMMARY="Limpeza concluída."
else
    # English Messages (Default)
    MSG_ROOT_REQUIRED="Error: This script must be run as root (sudo)."
    MSG_DRY_RUN_MODE="*** DRY-RUN MODE ENABLED. NO CHANGES WILL BE MADE. ***"
    MSG_CONFIRM_PROMPT="Do you confirm this step? (y/N): "
    MSG_DISTRO_DETECTED="Detected distribution:"
    MSG_CLEANING="Cleaning"
    MSG_CACHE="package manager cache"
    MSG_TEMP_FILES="temporary files"
    MSG_OLD_LOGS="old journal logs"
    MSG_ORPHAN_PACKAGES="orphan packages"
    MSG_BROWSER_CACHE="browser caches"
    MSG_FLATPAK="unused Flatpak runtimes"
    MSG_SNAP="old snap versions"
    MSG_SUMMARY="Cleaning complete."
fi

# --- Helper Functions ---

# Log messages to both console and log file
log() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

# Execute commands safely, respecting DRY_RUN
run_command() {
    local cmd_desc=$1
    shift
    local cmd=$*

    log "--> ${MSG_CLEANING} ${cmd_desc}..."

    if [[ $CONFIRM_EACH -eq 1 ]]; then
        read -p "$MSG_CONFIRM_PROMPT" -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[YysS]$ ]]; then
            log "    -> Etapa pulada pelo usuário."
            return
        fi
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        log "    [DRY-RUN] Command: $cmd"
    else
        log "    [LIVE] Executing: $cmd"
        # Execute command and redirect stdout/stderr to log file
        eval "$cmd" &>> "$LOG_FILE"
        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            log "    -> Sucesso."
        else
            log "    -> ERRO (Código de saída: $exit_code)."
        fi
    fi
}

# --- Cleaning Functions ---

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        log "Cannot detect distribution."
        exit 1
    fi
    log "$MSG_DISTRO_DETECTED $DISTRO"
}

clean_package_cache() {
    case $DISTRO in
        ubuntu|debian)
            run_command "$MSG_CACHE" "apt-get clean"
            ;;
        fedora)
            run_command "$MSG_CACHE" "dnf clean all"
            ;;
        arch)
            run_command "$MSG_CACHE" "paccache -r"
            ;;
        *)
            log "Gerenciador de pacotes para $DISTRO não suportado."
            ;;
    esac
}

clean_temp_files() {
    run_command "$MSG_TEMP_FILES" "rm -rf /tmp/* /var/tmp/*"
}

clean_old_logs() {
    run_command "$MSG_OLD_LOGS" "journalctl --vacuum-time=7d"
}

clean_orphan_packages() {
    if [[ $SECURE_MODE -eq 1 ]]; then
        log "--> Pulando limpeza de pacotes órfãos no modo seguro."
        return
    fi
    case $DISTRO in
        ubuntu|debian)
            run_command "$MSG_ORPHAN_PACKAGES" "apt-get autoremove -y"
            ;;
        fedora)
            run_command "$MSG_ORPHAN_PACKAGES" "dnf autoremove -y"
            ;;
        arch)
            # Be careful with orphan packages on Arch
            local orphans
            orphans=$(pacman -Qdtq)
            if [ -n "$orphans" ]; then
                run_command "$MSG_ORPHAN_PACKAGES" "pacman -Rns --noconfirm $orphans"
            else
                log "--> Nenhum pacote órfão encontrado."
            fi
            ;;
    esac
}

clean_browser_caches() {
    if [[ $SECURE_MODE -eq 1 ]]; then
        log "--> Pulando limpeza de cache de navegadores no modo seguro."
        return
    fi
    if [ -z "$SUDO_USER_HOME" ]; then
        log "--> Não foi possível encontrar o diretório home do usuário. Pulando cache de navegadores."
        return
    fi
    
    # Firefox
    if [ -d "$SUDO_USER_HOME/.mozilla/firefox" ]; then
        run_command "$MSG_BROWSER_CACHE (Firefox)" "find $SUDO_USER_HOME/.mozilla/firefox/ -name 'cache2' -type d -exec rm -rf {} + 2>/dev/null"
    fi
    # Chromium/Chrome
    if [ -d "$SUDO_USER_HOME/.cache/chromium" ]; then
        run_command "$MSG_BROWSER_CACHE (Chromium)" "rm -rf $SUDO_USER_HOME/.cache/chromium/Default/Cache/*"
    fi
     if [ -d "$SUDO_USER_HOME/.cache/google-chrome" ]; then
        run_command "$MSG_BROWSER_CACHE (Chrome)" "rm -rf $SUDO_USER_HOME/.cache/google-chrome/Default/Cache/*"
    fi
}

clean_flatpak() {
    if command -v flatpak &> /dev/null; then
        run_command "$MSG_FLATPAK" "flatpak uninstall --unused -y"
    fi
}

clean_snap() {
    if command -v snap &> /dev/null && [[ $SECURE_MODE -eq 0 ]]; then
        # This command removes disabled snap versions.
        run_command "$MSG_SNAP" "snap list --all | awk '/desativado/{print \$1, \$3}' | while read snapname revision; do snap remove \"\$snapname\" --revision=\"\$revision\"; done"
    fi
}

# --- Main Execution ---

show_help() {
    echo "Uso: sudo $0 [--dry-run] [--confirm] [--secure]"
    echo
    echo "  --dry-run   Mostra o que seria feito, sem executar as ações."
    echo "  --confirm   Pede confirmação antes de cada etapa de limpeza."
    echo "  --secure    Executa apenas as limpezas mais seguras (cache, logs, temp)."
    echo "  --help      Mostra esta ajuda."
    echo
    echo "O log completo será salvo em: $LOG_FILE"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=1 ;;
        --confirm) CONFIRM_EACH=1 ;;
        --secure) SECURE_MODE=1 ;;
        --help) show_help; exit 0 ;;
        *) echo "Opção desconhecida: $1"; show_help; exit 1 ;;
    esac
    shift
done

# --- Start Script ---
if [[ "$EUID" -ne 0 ]]; then
    echo "$MSG_ROOT_REQUIRED"
    exit 1
fi

# Setup log file
touch "$LOG_FILE"
chown "$SUDO_USER":root "$LOG_FILE"
log "================== INÍCIO DA LIMPEZA =================="

if [[ $DRY_RUN -eq 1 ]]; then
    log "$MSG_DRY_RUN_MODE"
}
if [[ $SECURE_MODE -eq 1 ]]; then
    log "Modo seguro ativado. Apenas ações não destrutivas serão executadas."
}

detect_distro
clean_package_cache
clean_temp_files
clean_old_logs
clean_orphan_packages
clean_browser_caches
clean_flatpak
clean_snap

log "$MSG_SUMMARY"
log "=================== FIM DA LIMPEZA ==================="
