#!/bin/bash

CONFIG_FILE="$HOME/.origins_config"

show_banner() {
    echo -e "\e[31m"
    echo "   ██████╗ "
    echo "  ██╔═══██╗"
    echo "  ██║   ██║"
    echo "  ██║   ██║"
    echo "  ╚██████╔╝"
    echo "   ╚═════╝ "
    echo -e "\e[0m   by Homaimyy"
    echo ""
}

usage() {
    echo -e "\e[36mOrigins, A Tool to Help You Find Your Origin by Youssef Alhomaimy\e[0m"
    echo ""
    echo -e "\e[31mUsage:\e[0m"
    echo "  $0 init <API_KEY>         Save VirusTotal API key (first-time setup)"
    echo "  $0 -d <domain> [-o file]  Query VirusTotal for IPs of domain"
    echo ""
    echo -e "\e[32mOptions:\e[0m"
    echo "  -d <domain>     Domain to query (required)"
    echo "  -o <file>       Save output to specified file"
    echo "  -h, --help      Show this help menu"
    echo ""
    echo -e "\e[33mExamples:\e[0m"
    echo "  $0 init 1234567890abcdef"
    echo "  $0 -d rapfame.app"
    echo "  $0 -d rapfame.app -o results.txt"
    exit 0
}

check_deps() {
    local missing=()

    for dep in wafw00f httpx-toolkit jq curl; do
        if ! command -v $dep &>/dev/null; then
            missing+=($dep)
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "[!] Missing dependencies: ${missing[*]}"
        read -p "Do you want to install them with apt? (y/n): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            sudo apt update && sudo apt install -y "${missing[@]}"
        else
            echo "[-] Cannot continue without installing dependencies."
            exit 1
        fi
    fi
}

init_api() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 init <VirusTotal_API_KEY>"
        exit 1
    fi

    check_deps
    echo "API_KEY=$1" > "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
    echo "[+] VirusTotal API key saved successfully to $CONFIG_FILE"
    exit 0
}

load_api() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "[!] No API key found. Please run:"
        echo "    $0 init <VirusTotal_API_KEY>"
        exit 1
    fi
    source "$CONFIG_FILE"
}

waf_check() {
    local domain="$1"
    echo "[*] Running WAF detection on $domain..."
    wafw00f "$domain"
    echo ""
}

query_vt() {
    local domain="$1"
    local outfile="$2"

    echo "[+] Querying VirusTotal for $domain..."
    results=$(curl -s --request GET \
        --url "https://www.virustotal.com/vtapi/v2/domain/report?domain=$domain&apikey=$API_KEY" \
        | jq -r '.. | .ip_address? // empty' \
        | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' \
        | sort -u \
        | httpx-toolkit -sc -td -title -server)

    if [[ -n "$outfile" ]]; then
        echo "$results" | tee "$outfile"
        echo "[+] Results saved to $outfile"
    else
        echo "$results"
    fi
}

# --- Main ---
if [[ "$1" == "init" ]]; then
    init_api "$2"
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

show_banner
load_api

if [[ $# -eq 0 ]]; then
    usage
fi

OUTFILE=""

while getopts "d:o:h" opt; do
    case "$opt" in
        d) DOMAIN=$OPTARG ;;
        o) OUTFILE=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -n "$DOMAIN" ]]; then
    waf_check "$DOMAIN"
    query_vt "$DOMAIN" "$OUTFILE"
else
    usage
fi

