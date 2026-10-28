#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "ERROR: instalación detenida en la línea $LINENO. Revisa el mensaje anterior." >&2' ERR

if [[ $EUID -eq 0 ]]; then
    echo 'Ejecuta con tu usuario normal: bash install_nvim_to_python.sh (sin sudo).'
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
NVIM_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
for item in init.lua lua lazy-lock.json; do
    if [[ ! -e "$SCRIPT_DIR/$item" ]]; then
        echo "Falta $item junto al instalador. Usa una copia completa del repositorio."
        exit 1
    fi
done

# Se valida antes de instalar paquetes o modificar archivos.
case "$(uname -m)" in
    x86_64) NVIM_ARCH=x86_64 ;;
    aarch64|arm64) NVIM_ARCH=arm64 ;;
    *) echo 'Arquitectura no compatible con este instalador.'; exit 1 ;;
esac

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_DIR"' EXIT

echo '1/4: instalando dependencias de Debian/Ubuntu...'
# No ocultar errores de APT ni modificar repositorios ajenos.
sudo apt-get update
sudo apt-get install -y ca-certificates git curl unzip ripgrep fzf \
    build-essential python3-pip python3-venv nodejs npm

# No basta con que nvim exista: los plugins requieren una versión mínima.
echo '2/4: comprobando Neovim (mínimo 0.11.3)...'
NVIM_BIN="$(command -v nvim || true)"
if [[ -z "$NVIM_BIN" ]] || ! "$NVIM_BIN" --clean --headless \
    '+lua if vim.fn.has("nvim-0.11.3") == 0 then vim.cmd("cquit 1") end' +qa; then
    ARCHIVE="nvim-linux-$NVIM_ARCH"
    curl -fL --retry 3 \
        "https://github.com/neovim/neovim/releases/latest/download/$ARCHIVE.tar.gz" \
        -o "$TEMP_DIR/nvim.tar.gz"
    tar -xzf "$TEMP_DIR/nvim.tar.gz" -C "$TEMP_DIR"
    # Comprobar compatibilidad del binario antes de instalarlo.
    "$TEMP_DIR/$ARCHIVE/bin/nvim" --clean --headless \
        '+lua if vim.fn.has("nvim-0.11.3") == 0 then vim.cmd("cquit 1") end' +qa
    NVIM_VERSION="$("$TEMP_DIR/$ARCHIVE/bin/nvim" --version | head -n 1)"
    NVIM_VERSION="${NVIM_VERSION#NVIM }"
    INSTALL_DIR="/opt/neovim-${NVIM_VERSION}-$(date +%Y%m%d-%H%M%S)-$$"
    sudo mkdir -p /opt /usr/local/bin
    sudo mv -- "$TEMP_DIR/$ARCHIVE" "$INSTALL_DIR"
    # Conservar un ejecutable o enlace local anterior antes de sustituirlo.
    if [[ -e /usr/local/bin/nvim || -L /usr/local/bin/nvim ]]; then
        sudo mv /usr/local/bin/nvim "/usr/local/bin/nvim.bak.$(date +%Y%m%d-%H%M%S)-$$"
    fi
    sudo ln -s "$INSTALL_DIR/bin/nvim" /usr/local/bin/nvim
    NVIM_BIN=/usr/local/bin/nvim
fi
"$NVIM_BIN" --version | head -n 1

echo '3/4: preparando configuración...'
mkdir -p -- "$(dirname -- "$NVIM_DEST")"
if [[ "$(realpath -m -- "$SCRIPT_DIR")" == "$(realpath -m -- "$NVIM_DEST")" ]]; then
    echo 'El repositorio ya está en la ruta de configuración; no se mueve ni se copia.'
else
    # Evitar copiar una configuración dentro de sí misma o mover el origen.
    case "$(realpath -m -- "$SCRIPT_DIR")/" in
        "$(realpath -m -- "$NVIM_DEST")/"*)
            echo 'El repositorio está dentro de la configuración de destino. Muévelo fuera y reintenta.'
            exit 1 ;;
    esac
    case "$(realpath -m -- "$NVIM_DEST")/" in
        "$SCRIPT_DIR/"*) echo 'El destino no puede estar dentro del repositorio.'; exit 1 ;;
    esac
    if [[ -e "$NVIM_DEST" || -L "$NVIM_DEST" ]]; then
        BACKUP="${NVIM_DEST}.bak.$(date +%Y%m%d-%H%M%S)-$$"
        mv -- "$NVIM_DEST" "$BACKUP"
        echo "Respaldo anterior: $BACKUP"
    fi
    mkdir -p -- "$NVIM_DEST"
    cp -a -- "$SCRIPT_DIR/init.lua" "$SCRIPT_DIR/lua" \
        "$SCRIPT_DIR/lazy-lock.json" "$NVIM_DEST/"
fi

echo '4/4: restaurando las versiones de plugins de lazy-lock.json...'
# install descarga los ausentes; restore aplica los commits registrados.
"$NVIM_BIN" --headless '+Lazy! install' '+Lazy! restore' +qa

echo 'Listo. Ejecuta: nvim'
echo 'Verifica :checkhealth y :Mason. Las instalaciones de servidores pueden tardar.'
echo 'En otra terminal nueva, nvim --version debe mostrar 0.11.3 o superior.'
