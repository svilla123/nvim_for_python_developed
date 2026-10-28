#!/usr/bin/env bash
# Diagnóstico de solo lectura: no instala paquetes ni solicita contraseñas.
set -uo pipefail

MODE=full
case "${1:-}" in
    '') ;;
    --bootstrap) MODE=bootstrap ;;
    -h|--help)
        printf '%s\n' 'Uso: bash check_system.sh [--bootstrap]' \
            'Sin opciones: revisa dependencias del editor.' \
            '--bootstrap: revisa lo necesario para descargar/clonar el repositorio.' \
            'Salida: 0 = comprobaciones obligatorias correctas; 1 = faltan requisitos; 2 = uso incorrecto.'
        exit 0 ;;
    *) printf 'Opción desconocida: %s\n' "$1" >&2; exit 2 ;;
esac
if (( $# > 1 )); then printf 'Demasiados argumentos. Usa --help.\n' >&2; exit 2; fi

missing=()
errors=0
warnings=0
add_package() {
    local package="$1" item
    for item in "${missing[@]}"; do [[ "$item" == "$package" ]] && return 0; done
    missing+=("$package")
}
check_command() {
    local executable="$1" package="$2" reason="$3"
    if command -v "$executable" >/dev/null 2>&1; then
        printf '[OK]    %s: %s\n' "$executable" "$reason"
    else
        printf '[FALTA] %s: %s (paquete: %s)\n' "$executable" "$reason" "$package"
        add_package "$package"
        errors=$((errors + 1))
    fi
}
warn() { printf '[AVISO] %s\n' "$1"; warnings=$((warnings + 1)); }

printf 'Diagnóstico Neovim / modo: %s\n\n' "$MODE"
if ! command -v apt-get >/dev/null 2>&1; then
    printf '[FALTA] apt-get: el instalador requiere Debian/Ubuntu con APT.\n'
    errors=$((errors + 1))
fi
architecture="$(uname -m 2>/dev/null || printf desconocida)"
case "$architecture" in
    x86_64|aarch64|arm64) printf '[OK]    Arquitectura: %s\n' "$architecture" ;;
    *) printf '[FALTA] Arquitectura no admitida por el instalador: %s\n' "$architecture"; errors=$((errors + 1)) ;;
esac

if [[ $EUID -ne 0 ]]; then
    check_command sudo sudo 'instalar dependencias del sistema'
else
    warn 'Estás como root. Puedes diagnosticar, pero ejecuta el instalador con tu usuario normal.'
fi
check_command git git 'clonar el repositorio y descargar plugins'
check_command curl curl 'descargar archivos por HTTPS'
if [[ -s /etc/ssl/certs/ca-certificates.crt ]]; then
    printf '[OK]    Certificados CA: almacén del sistema presente\n'
else
    printf '[FALTA] Certificados CA para HTTPS (paquete: ca-certificates)\n'
    add_package ca-certificates
    errors=$((errors + 1))
fi

if [[ "$MODE" == full ]]; then
    check_command tar tar 'descomprimir Neovim y analizadores'
    check_command gzip gzip 'descomprimir archivos .gz'
    check_command unzip unzip 'extraer herramientas descargadas'
    check_command cc build-essential 'compilar analizadores de Treesitter'
    check_command make build-essential 'construir herramientas'
    check_command rg ripgrep 'buscar texto en proyectos'
    check_command fzf fzf 'búsqueda interactiva'
    check_command python3 python3 'ejecutar Python'
    if command -v python3 >/dev/null 2>&1; then
        if python3 -m pip --version >/dev/null 2>&1; then
            printf '[OK]    pip: disponible para python3\n'
        else
            printf '[FALTA] pip para python3 (paquete: python3-pip)\n'
            add_package python3-pip; errors=$((errors + 1))
        fi
        # ensurepip comprueba el soporte usado al crear un venv con pip.
        if python3 -c 'import venv, ensurepip' >/dev/null 2>&1; then
            printf '[OK]    venv/ensurepip: módulos disponibles\n'
        else
            printf '[FALTA] venv/ensurepip (paquete: python3-venv)\n'
            add_package python3-venv; errors=$((errors + 1))
        fi
    fi
    check_command node nodejs 'ejecutar servidores como Pyright'
    check_command npm npm 'instalar herramientas JavaScript'
    if command -v nvim >/dev/null 2>&1; then
        if nvim --clean --headless '+lua if vim.fn.has("nvim-0.11.3") == 0 then vim.cmd("cquit 1") end' +qa >/dev/null 2>&1; then
            printf '[OK]    Neovim: versión >= 0.11.3 y arranque básico correcto\n'
        else
            warn 'Neovim es antiguo o no arranca. El instalador intentará instalar la versión estable oficial.'
        fi
    else
        warn 'Neovim no está instalado; el instalador lo descargará.'
    fi
fi

printf '\nResumen: %s requisitos pendientes; %s avisos.\n' "$errors" "$warnings"
if (( ${#missing[@]} > 0 )); then
    printf '\nPaquetes que faltan según las comprobaciones:\n'
    printf 'sudo apt update\n'
    printf 'sudo apt install'; printf ' %s' "${missing[@]}"; printf '\n'
    if ! command -v sudo >/dev/null 2>&1 && [[ $EUID -ne 0 ]]; then
        printf 'Si falta sudo, un administrador debe instalar los paquetes desde root, sin el prefijo sudo.\n'
    fi
    printf 'Los nombres indicados corresponden a Python y paquetes estándar de Debian/Ubuntu.\n'
    printf 'Si usas otro Python (Conda/pyenv), instalar el paquete APT puede no corregir ese intérprete.\n'
fi
printf '\nEste diagnóstico no instala ni cambia archivos. No comprueba Internet, firmas APT,\npermisos sudo, versiones de Node, servidores LSP ni descargas de plugins.\n'
if (( errors > 0 )); then exit 1; fi
if [[ "$MODE" == bootstrap ]]; then
    printf '\nHerramientas locales para descargar/clonar disponibles.\n'
else
    printf '\nDependencias comprobadas disponibles. Continúa con bash install_nvim_to_python.sh\n'
fi
