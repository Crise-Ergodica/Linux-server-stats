#!/bin/bash

################################################################################
# server-stats.sh - Linux Server Performance Statistics Analyzer
# 
# Description:
#   Script para análise de estatísticas básicas de desempenho de servidor Linux.
#   Fornece informações detalhadas sobre uso de CPU, memória, disco, processos
#   e estatísticas adicionais do sistema.
#
# Author: Aurora Ergodica
# Repository: https://github.com/Crise-Ergodica/Linux-server-stats
# License: MIT
################################################################################

# Cores para output formatado
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Símbolos para melhor visualização
CHECK="${GREEN}✓${RESET}"
INFO="${BLUE}ℹ${RESET}"
WARN="${YELLOW}⚠${RESET}"

################################################################################
# Função: print_header
# Descrição: Imprime cabeçalho formatado para cada seção
################################################################################
print_header() {
    local title="$1"
    echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${CYAN}  $title${RESET}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

################################################################################
# Função: print_banner
# Descrição: Imprime banner inicial do script
################################################################################
print_banner() {
    echo -e "${BOLD}${MAGENTA}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║          Linux Server Statistics Analyzer                 ║"
    echo "║              Performance Monitoring Tool                  ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${INFO} Report Generated: ${BOLD}$(date '+%Y-%m-%d %H:%M:%S %Z')${RESET}\n"
}

################################################################################
# Função: get_os_info
# Descrição: Obtém informações sobre o sistema operacional
################################################################################
get_os_info() {
    print_header "📋 System Information"
    
    # Nome do sistema operacional
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo -e "${BOLD}OS Name:${RESET}         $NAME"
        echo -e "${BOLD}OS Version:${RESET}      $VERSION"
        echo -e "${BOLD}OS ID:${RESET}           $ID"
    else
        echo -e "${BOLD}OS:${RESET}              $(uname -s)"
    fi
    
    # Kernel version
    echo -e "${BOLD}Kernel Version:${RESET}  $(uname -r)"
    
    # Arquitetura
    echo -e "${BOLD}Architecture:${RESET}    $(uname -m)"
    
    # Hostname
    echo -e "${BOLD}Hostname:${RESET}        $(hostname)"
}

################################################################################
# Função: get_uptime_info
# Descrição: Obtém informações sobre tempo de atividade e carga
################################################################################
get_uptime_info() {
    print_header "⏱️  Uptime & Load Average"
    
    # Uptime formatado
    local uptime_seconds=$(cat /proc/uptime | awk '{print int($1)}')
    local days=$((uptime_seconds / 86400))
    local hours=$(((uptime_seconds % 86400) / 3600))
    local minutes=$(((uptime_seconds % 3600) / 60))
    
    echo -e "${BOLD}System Uptime:${RESET}   ${days} days, ${hours} hours, ${minutes} minutes"
    
    # Load average
    local load_avg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    echo -e "${BOLD}Load Average:${RESET}    ${load_avg} (1min, 5min, 15min)"
    
    # Número de CPUs
    local cpu_count=$(nproc)
    echo -e "${BOLD}CPU Cores:${RESET}       ${cpu_count}"
    
    # Análise de carga
    local load_1min=$(cat /proc/loadavg | awk '{print $1}')
    local load_percentage=$(echo "scale=2; ($load_1min / $cpu_count) * 100" | bc)
    
    if (( $(echo "$load_percentage < 70" | bc -l) )); then
        echo -e "${BOLD}Load Status:${RESET}     ${GREEN}Normal${RESET} (${load_percentage}% of capacity)"
    elif (( $(echo "$load_percentage < 90" | bc -l) )); then
        echo -e "${BOLD}Load Status:${RESET}     ${YELLOW}Moderate${RESET} (${load_percentage}% of capacity)"
    else
        echo -e "${BOLD}Load Status:${RESET}     ${RED}High${RESET} (${load_percentage}% of capacity)"
    fi
}

################################################################################
# Função: get_cpu_usage
# Descrição: Calcula uso total da CPU
################################################################################
get_cpu_usage() {
    print_header "🖥️  CPU Usage"
    
    # Captura snapshot inicial
    local cpu_stats1=$(cat /proc/stat | grep '^cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    sleep 1
    # Captura snapshot após 1 segundo
    local cpu_stats2=$(cat /proc/stat | grep '^cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    
    # Calcula diferenças
    local idle1=$(echo $cpu_stats1 | awk '{print $4}')
    local idle2=$(echo $cpu_stats2 | awk '{print $4}')
    
    local total1=$(echo $cpu_stats1 | awk '{sum=0; for(i=1; i<=NF; i++) sum+=$i; print sum}')
    local total2=$(echo $cpu_stats2 | awk '{sum=0; for(i=1; i<=NF; i++) sum+=$i; print sum}')
    
    local idle_diff=$((idle2 - idle1))
    local total_diff=$((total2 - total1))
    
    # Calcula porcentagem de uso
    local cpu_usage=$(echo "scale=2; 100 * ($total_diff - $idle_diff) / $total_diff" | bc)
    
    echo -e "${BOLD}Total CPU Usage:${RESET} ${cpu_usage}%"
    
    # Barra de progresso visual
    local bar_length=50
    local filled=$(echo "scale=0; $cpu_usage * $bar_length / 100" | bc)
    local empty=$((bar_length - filled))
    
    echo -ne "${BOLD}Progress:${RESET}        ["
    
    # Cor baseada no uso
    if (( $(echo "$cpu_usage < 50" | bc -l) )); then
        echo -ne "${GREEN}"
    elif (( $(echo "$cpu_usage < 80" | bc -l) )); then
        echo -ne "${YELLOW}"
    else
        echo -ne "${RED}"
    fi
    
    # Desenha barra
    printf '%*s' "$filled" | tr ' ' '█'
    echo -ne "${RESET}"
    printf '%*s' "$empty" | tr ' ' '░'
    echo "]"
    
    # Informações por núcleo (se disponível)
    echo -e "\n${BOLD}Per-Core Usage:${RESET}"
    mpstat -P ALL 1 1 2>/dev/null | grep -E '^Average' | grep -v 'CPU' | awk '{
        printf "  Core %-2s: %5.2f%%\n", $2, 100-$NF
    }' || echo "  ${WARN} mpstat not available (install sysstat package)"
}

################################################################################
# Função: get_memory_usage
# Descrição: Obtém estatísticas de uso de memória
################################################################################
get_memory_usage() {
    print_header "💾 Memory Usage"
    
    # Lê informações do /proc/meminfo
    local mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
    local mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    local buffers=$(grep Buffers /proc/meminfo | awk '{print $2}')
    local cached=$(grep "^Cached" /proc/meminfo | awk '{print $2}')
    
    # Calcula uso real (excluindo buffers/cache)
    local mem_used=$((mem_total - mem_available))
    
    # Converte para unidades legíveis
    local total_gb=$(echo "scale=2; $mem_total / 1048576" | bc)
    local used_gb=$(echo "scale=2; $mem_used / 1048576" | bc)
    local free_gb=$(echo "scale=2; $mem_available / 1048576" | bc)
    local buffers_gb=$(echo "scale=2; $buffers / 1048576" | bc)
    local cached_gb=$(echo "scale=2; $cached / 1048576" | bc)
    
    # Calcula porcentagem
    local mem_percent=$(echo "scale=2; 100 * $mem_used / $mem_total" | bc)
    
    echo -e "${BOLD}Total Memory:${RESET}    ${total_gb} GB"
    echo -e "${BOLD}Used Memory:${RESET}     ${used_gb} GB (${mem_percent}%)"
    echo -e "${BOLD}Free Memory:${RESET}     ${free_gb} GB"
    echo -e "${BOLD}Buffers:${RESET}         ${buffers_gb} GB"
    echo -e "${BOLD}Cached:${RESET}          ${cached_gb} GB"
    
    # Barra de progresso
    local bar_length=50
    local filled=$(echo "scale=0; $mem_percent * $bar_length / 100" | bc)
    local empty=$((bar_length - filled))
    
    echo -ne "${BOLD}Progress:${RESET}        ["
    
    if (( $(echo "$mem_percent < 60" | bc -l) )); then
        echo -ne "${GREEN}"
    elif (( $(echo "$mem_percent < 85" | bc -l) )); then
        echo -ne "${YELLOW}"
    else
        echo -ne "${RED}"
    fi
    
    printf '%*s' "$filled" | tr ' ' '█'
    echo -ne "${RESET}"
    printf '%*s' "$empty" | tr ' ' '░'
    echo "]"
    
    # Informações de swap
    echo -e "\n${BOLD}Swap Memory:${RESET}"
    local swap_total=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
    local swap_free=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    local swap_used=$((swap_total - swap_free))
    
    if [ $swap_total -gt 0 ]; then
        local swap_total_gb=$(echo "scale=2; $swap_total / 1048576" | bc)
        local swap_used_gb=$(echo "scale=2; $swap_used / 1048576" | bc)
        local swap_percent=$(echo "scale=2; 100 * $swap_used / $swap_total" | bc)
        echo -e "  Total: ${swap_total_gb} GB | Used: ${swap_used_gb} GB (${swap_percent}%)"
    else
        echo -e "  ${INFO} No swap configured"
    fi
}

################################################################################
# Função: get_disk_usage
# Descrição: Obtém estatísticas de uso de disco
################################################################################
get_disk_usage() {
    print_header "💿 Disk Usage"
    
    echo -e "${BOLD}Filesystem Statistics:${RESET}\n"
    
    # Usa df para obter informações de todos os filesystems
    df -h --output=source,fstype,size,used,avail,pcent,target | grep -v tmpfs | grep -v devtmpfs | grep -v "loop" | while IFS= read -r line; do
        if [[ $line == *"Filesystem"* ]]; then
            echo -e "${BOLD}$line${RESET}"
        else
            # Extrai porcentagem de uso
            local usage=$(echo $line | awk '{print $6}' | tr -d '%')
            
            if [ -n "$usage" ] && [ "$usage" -eq "$usage" ] 2>/dev/null; then
                if [ $usage -lt 70 ]; then
                    echo -e "${GREEN}$line${RESET}"
                elif [ $usage -lt 90 ]; then
                    echo -e "${YELLOW}$line${RESET}"
                else
                    echo -e "${RED}$line${RESET}"
                fi
            else
                echo "$line"
            fi
        fi
    done
    
    # Estatísticas agregadas
    echo -e "\n${BOLD}Total Disk Space Summary:${RESET}"
    local total_space=$(df --total -h | grep total | awk '{print $2}')
    local used_space=$(df --total -h | grep total | awk '{print $3}')
    local avail_space=$(df --total -h | grep total | awk '{print $4}')
    local usage_percent=$(df --total -h | grep total | awk '{print $5}')
    
    echo -e "  Total: ${BOLD}$total_space${RESET} | Used: ${BOLD}$used_space${RESET} | Available: ${BOLD}$avail_space${RESET} | Usage: ${BOLD}$usage_percent${RESET}"
}

################################################################################
# Função: get_top_cpu_processes
# Descrição: Lista os 5 processos com maior uso de CPU
################################################################################
get_top_cpu_processes() {
    print_header "🔥 Top 5 Processes by CPU Usage"
    
    echo -e "${BOLD}PID       USER       CPU%    MEM%    COMMAND${RESET}"
    echo -e "${BOLD}────────────────────────────────────────────────────────${RESET}"
    
    ps aux --sort=-%cpu | head -n 6 | tail -n 5 | awk '{
        printf "%-9s %-10s %-7s %-7s %s\n", $2, $1, $3"%", $4"%", $11
    }'
}

################################################################################
# Função: get_top_memory_processes
# Descrição: Lista os 5 processos com maior uso de memória
################################################################################
get_top_memory_processes() {
    print_header "🧠 Top 5 Processes by Memory Usage"
    
    echo -e "${BOLD}PID       USER       CPU%    MEM%    COMMAND${RESET}"
    echo -e "${BOLD}────────────────────────────────────────────────────────${RESET}"
    
    ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{
        printf "%-9s %-10s %-7s %-7s %s\n", $2, $1, $3"%", $4"%", $11
    }'
}

################################################################################
# Função: get_network_info
# Descrição: Obtém estatísticas de rede
################################################################################
get_network_info() {
    print_header "🌐 Network Statistics"
    
    echo -e "${BOLD}Active Network Interfaces:${RESET}\n"
    
    # Lista interfaces ativas
    ip -brief addr show | grep -v "lo" | while read -r line; do
        echo "  $line"
    done
    
    echo -e "\n${BOLD}Network Connections Summary:${RESET}"
    
    local established=$(ss -tan | grep ESTAB | wc -l)
    local listen=$(ss -tln | grep LISTEN | wc -l)
    local time_wait=$(ss -tan | grep TIME-WAIT | wc -l)
    
    echo -e "  ${BOLD}Established:${RESET} $established"
    echo -e "  ${BOLD}Listening:${RESET}   $listen"
    echo -e "  ${BOLD}Time-Wait:${RESET}   $time_wait"
}

################################################################################
# Função: get_user_info
# Descrição: Obtém informações sobre usuários conectados
################################################################################
get_user_info() {
    print_header "👥 User Sessions"
    
    local user_count=$(who | wc -l)
    echo -e "${BOLD}Currently logged in users:${RESET} $user_count\n"
    
    if [ $user_count -gt 0 ]; then
        echo -e "${BOLD}USER       TTY      FROM             LOGIN@   IDLE${RESET}"
        echo -e "${BOLD}────────────────────────────────────────────────────────${RESET}"
        who -u | awk '{printf "%-10s %-8s %-16s %-8s %s\n", $1, $2, $6, $3" "$4, $5}'
    fi
}

################################################################################
# Função: get_failed_logins
# Descrição: Verifica tentativas de login falhas (requer privilégios root)
################################################################################
get_failed_logins() {
    print_header "🔒 Security: Failed Login Attempts"
    
    if [ -f /var/log/auth.log ]; then
        local failed_count=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
        echo -e "${BOLD}Failed login attempts:${RESET} $failed_count (from auth.log)"
        
        if [ $failed_count -gt 0 ]; then
            echo -e "\n${BOLD}Recent failed attempts (last 5):${RESET}"
            grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5 | awk '{
                print "  " $1, $2, $3, $11, "from", $13
            }'
        fi
    elif [ -f /var/log/secure ]; then
        local failed_count=$(grep "Failed password" /var/log/secure 2>/dev/null | wc -l)
        echo -e "${BOLD}Failed login attempts:${RESET} $failed_count (from secure.log)"
        
        if [ $failed_count -gt 0 ]; then
            echo -e "\n${BOLD}Recent failed attempts (last 5):${RESET}"
            grep "Failed password" /var/log/secure 2>/dev/null | tail -n 5 | awk '{
                print "  " $1, $2, $3, $11, "from", $13
            }'
        fi
    else
        echo -e "${WARN} Unable to access authentication logs (requires root privileges)"
    fi
}

################################################################################
# Função: get_service_status
# Descrição: Mostra status de serviços importantes
################################################################################
get_service_status() {
    print_header "⚙️  Critical Services Status"
    
    # Lista de serviços comuns para verificar
    local services=("sshd" "ssh" "cron" "nginx" "apache2" "mysql" "postgresql" "docker")
    
    echo -e "${BOLD}SERVICE       STATUS${RESET}"
    echo -e "${BOLD}────────────────────────────${RESET}"
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "^${service}.service"; then
            if systemctl is-active --quiet "$service"; then
                echo -e "${service,,}$(printf '%-15s' | tr ' ' ' ')${GREEN}● active${RESET}"
            else
                echo -e "${service,,}$(printf '%-15s' | tr ' ' ' ')${RED}○ inactive${RESET}"
            fi
        fi
    done
}

################################################################################
# Função: main
# Descrição: Função principal que executa todas as análises
################################################################################
main() {
    # Verifica se está rodando em Linux
    if [ "$(uname -s)" != "Linux" ]; then
        echo -e "${RED}Error: This script only runs on Linux systems.${RESET}"
        exit 1
    fi
    
    # Banner inicial
    print_banner
    
    # Executa todas as funções de análise
    get_os_info
    get_uptime_info
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_top_cpu_processes
    get_top_memory_processes
    get_network_info
    get_user_info
    get_failed_logins
    get_service_status
    
    # Footer
    echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${INFO} Report generated successfully at $(date '+%H:%M:%S')"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

# Executa o script
main
