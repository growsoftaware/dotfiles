#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                          DOTFILES INSTALLER                               ║
# ║                                                                          ║
# ║  Configura automaticamente:                                              ║
# ║    • Alacritty (terminal GPU-accelerated)                                ║
# ║    • tmux (multiplexador de terminal)                                    ║
# ║    • Vim (editor com plugins)                                            ║
# ║    • lazygit (TUI para Git)                                              ║
# ║    • delta (pager para diffs)                                            ║
# ║    • Fonte JetBrains Mono                                                ║
# ║                                                                          ║
# ║  Tema: Catppuccin Mocha                                                  ║
# ║                                                                          ║
# ║  Compatível com: Ubuntu/Debian, Fedora, Arch, macOS                      ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# USO:
#   chmod +x install.sh
#   ./install.sh
#
# OPÇÕES:
#   ./install.sh --help     Mostra esta ajuda
#   ./install.sh --dry-run  Simula sem instalar
#

set -e

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}${BOLD}                    DOTFILES INSTALLER                        ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}==>${NC} ${BOLD}$1${NC}"
}

print_substep() {
    echo -e "    ${CYAN}→${NC} $1"
}

print_success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "    ${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "    ${RED}✗${NC} $1"
}

print_help() {
    echo "USO: ./install.sh [opções]"
    echo ""
    echo "OPÇÕES:"
    echo "  --help      Mostra esta ajuda"
    echo "  --dry-run   Simula a instalação sem fazer alterações"
    echo ""
    echo "O QUE SERÁ INSTALADO:"
    echo "  • Dependências: tmux, vim, fzf, ripgrep, xclip, lazygit, delta"
    echo "  • Fonte: JetBrains Mono"
    echo "  • Configs: Alacritty, tmux, Vim, lazygit, Git"
    echo "  • Tema: Catppuccin Mocha"
    echo ""
    echo "ATALHOS PRINCIPAIS:"
    echo "  • Ctrl+a h        Cheatsheet (dentro do tmux)"
    echo "  • Ctrl+a |        Dividir terminal vertical"
    echo "  • Ctrl+a -        Dividir terminal horizontal"
    echo "  • Espaço+f        Buscar arquivos (vim)"
    echo ""
}

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "    ${YELLOW}[dry-run]${NC} $*"
    else
        "$@"
    fi
}

# ============================================================================
# DETECÇÃO DO SISTEMA
# ============================================================================

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

detect_pkg_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "brew"
    elif command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# ============================================================================
# INSTALAÇÃO DE PACOTES
# ============================================================================

install_pkg() {
    local pkg="$1"
    local pkg_apt="${2:-$pkg}"
    local pkg_dnf="${3:-$pkg}"
    local pkg_pacman="${4:-$pkg}"
    local pkg_brew="${5:-$pkg}"

    case $PKG_MANAGER in
        apt)
            run_cmd sudo apt install -y "$pkg_apt"
            ;;
        dnf)
            run_cmd sudo dnf install -y "$pkg_dnf"
            ;;
        pacman)
            run_cmd sudo pacman -S --noconfirm "$pkg_pacman"
            ;;
        brew)
            run_cmd brew install "$pkg_brew"
            ;;
        *)
            print_warning "Instale manualmente: $pkg"
            return 1
            ;;
    esac
}

install_if_missing() {
    local cmd="$1"
    local name="${2:-$cmd}"
    shift 2

    if command -v "$cmd" &> /dev/null; then
        print_success "$name já instalado"
        return 0
    fi

    print_substep "Instalando $name..."
    if install_pkg "$@"; then
        print_success "$name instalado"
    else
        print_error "Falha ao instalar $name"
        return 1
    fi
}

# ============================================================================
# INSTALAÇÃO DA FONTE
# ============================================================================

install_font() {
    print_step "Instalando fonte JetBrains Mono..."

    # Verifica se já está instalada
    if fc-list 2>/dev/null | grep -qi "JetBrains Mono"; then
        print_success "JetBrains Mono já instalada"
        return 0
    fi

    # Diretório de fontes
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi

    run_cmd mkdir -p "$FONT_DIR"

    # Copia as fontes do repositório
    if [ -d "$DOTFILES_DIR/fonts" ]; then
        print_substep "Copiando fontes do repositório..."
        run_cmd cp "$DOTFILES_DIR/fonts/"*.ttf "$FONT_DIR/"

        # Atualiza cache (Linux)
        if [[ "$OSTYPE" != "darwin"* ]]; then
            run_cmd fc-cache -f
        fi

        print_success "JetBrains Mono instalada"
    else
        print_warning "Pasta fonts/ não encontrada, instalando via gerenciador..."
        case $PKG_MANAGER in
            apt)
                run_cmd sudo apt install -y fonts-jetbrains-mono
                ;;
            dnf)
                run_cmd sudo dnf install -y jetbrains-mono-fonts
                ;;
            pacman)
                run_cmd sudo pacman -S --noconfirm ttf-jetbrains-mono
                ;;
            brew)
                run_cmd brew install --cask font-jetbrains-mono
                ;;
        esac
    fi
}

# ============================================================================
# INSTALAÇÃO DO ALACRITTY
# ============================================================================

install_alacritty() {
    print_step "Verificando Alacritty..."

    if command -v alacritty &> /dev/null; then
        print_success "Alacritty já instalado ($(alacritty --version 2>/dev/null | head -1))"
        return 0
    fi

    print_substep "Alacritty não encontrado"

    case $PKG_MANAGER in
        apt)
            print_warning "No Ubuntu/Debian, instale via:"
            echo "         sudo add-apt-repository ppa:aslatter/ppa"
            echo "         sudo apt install alacritty"
            echo "      Ou: cargo install alacritty"
            ;;
        pacman)
            print_substep "Instalando via pacman..."
            run_cmd sudo pacman -S --noconfirm alacritty
            ;;
        brew)
            print_substep "Instalando via Homebrew..."
            run_cmd brew install --cask alacritty
            ;;
        dnf)
            print_warning "No Fedora, instale via: sudo dnf install alacritty"
            echo "      Ou: cargo install alacritty"
            ;;
        *)
            print_warning "Instale Alacritty manualmente: cargo install alacritty"
            ;;
    esac
}

# ============================================================================
# INSTALAÇÃO DO LAZYGIT
# ============================================================================

install_lazygit() {
    print_step "Instalando lazygit..."

    if command -v lazygit &> /dev/null; then
        print_success "lazygit já instalado ($(lazygit --version 2>/dev/null | head -1))"
        return 0
    fi

    case $PKG_MANAGER in
        apt)
            # lazygit não está nos repos padrão, usa o release do GitHub
            print_substep "Baixando lazygit do GitHub..."
            if [ "$DRY_RUN" = false ]; then
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
                sudo install /tmp/lazygit /usr/local/bin
                rm /tmp/lazygit /tmp/lazygit.tar.gz
            fi
            print_success "lazygit instalado"
            ;;
        dnf)
            run_cmd sudo dnf copr enable atim/lazygit -y
            run_cmd sudo dnf install -y lazygit
            print_success "lazygit instalado"
            ;;
        pacman)
            run_cmd sudo pacman -S --noconfirm lazygit
            print_success "lazygit instalado"
            ;;
        brew)
            run_cmd brew install lazygit
            print_success "lazygit instalado"
            ;;
        *)
            print_warning "Instale lazygit manualmente: https://github.com/jesseduffield/lazygit#installation"
            ;;
    esac
}

# ============================================================================
# INSTALAÇÃO DO DELTA
# ============================================================================

install_delta() {
    print_step "Instalando delta (pager para diffs)..."

    if command -v delta &> /dev/null; then
        print_success "delta já instalado ($(delta --version 2>/dev/null | head -1))"
        return 0
    fi

    case $PKG_MANAGER in
        apt)
            # delta não está nos repos padrão, usa o release do GitHub
            print_substep "Baixando delta do GitHub..."
            if [ "$DRY_RUN" = false ]; then
                DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
                curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
                sudo dpkg -i /tmp/delta.deb
                rm /tmp/delta.deb
            fi
            print_success "delta instalado"
            ;;
        dnf)
            run_cmd sudo dnf install -y git-delta
            print_success "delta instalado"
            ;;
        pacman)
            run_cmd sudo pacman -S --noconfirm git-delta
            print_success "delta instalado"
            ;;
        brew)
            run_cmd brew install git-delta
            print_success "delta instalado"
            ;;
        *)
            print_warning "Instale delta manualmente: https://github.com/dandavison/delta#installation"
            ;;
    esac
}

# ============================================================================
# CONFIGURAÇÃO DOS SYMLINKS
# ============================================================================

setup_symlinks() {
    print_step "Configurando symlinks..."

    # Criar diretórios necessários
    run_cmd mkdir -p ~/.config/alacritty
    run_cmd mkdir -p ~/.config/tmux
    run_cmd mkdir -p ~/.config/lazygit

    # Função para criar symlink com backup
    create_symlink() {
        local src="$1"
        local dest="$2"
        local name="$3"

        # Se já é um symlink correto, pula
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            print_success "$name já configurado"
            return 0
        fi

        # Backup se existir arquivo real
        if [ -f "$dest" ] && [ ! -L "$dest" ]; then
            print_substep "Backup: $dest → $dest.bak"
            run_cmd mv "$dest" "$dest.bak"
        fi

        # Remove symlink antigo se existir
        [ -L "$dest" ] && run_cmd rm "$dest"

        # Cria novo symlink
        run_cmd ln -sf "$src" "$dest"
        print_success "$name → $dest"
    }

    create_symlink "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml "Alacritty"
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf "tmux"
    create_symlink "$DOTFILES_DIR/vim/.vimrc" ~/.vimrc "Vim"
    create_symlink "$DOTFILES_DIR/lazygit/config.yml" ~/.config/lazygit/config.yml "lazygit"
    create_symlink "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig "Git"

    # Scripts do tmux (diretório)
    if [ -L ~/.config/tmux/scripts ]; then
        run_cmd rm ~/.config/tmux/scripts
    elif [ -d ~/.config/tmux/scripts ]; then
        run_cmd rm -rf ~/.config/tmux/scripts
    fi
    run_cmd ln -sf "$DOTFILES_DIR/tmux/scripts" ~/.config/tmux/scripts
    print_success "tmux scripts → ~/.config/tmux/scripts"
}

# ============================================================================
# VIM PLUGINS
# ============================================================================

setup_vim() {
    print_step "Configurando Vim..."

    # Instala vim-plug se necessário
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        print_substep "Instalando vim-plug..."
        run_cmd curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        print_success "vim-plug instalado"
    else
        print_success "vim-plug já instalado"
    fi

    # Instala plugins
    print_substep "Instalando plugins do Vim..."
    if [ "$DRY_RUN" = false ]; then
        vim +PlugInstall +qall 2>/dev/null || true
    fi
    print_success "Plugins instalados"
}

# ============================================================================
# CONFIGURAÇÕES DO SISTEMA (Linux)
# ============================================================================

setup_linux_extras() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        return 0
    fi

    print_step "Configurações extras (Linux)..."

    # Terminal padrão
    if command -v alacritty &> /dev/null; then
        ALACRITTY_PATH=$(which alacritty)
        print_substep "Configurando Alacritty como terminal padrão..."
        run_cmd sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$ALACRITTY_PATH" 50 2>/dev/null || true
        run_cmd sudo update-alternatives --set x-terminal-emulator "$ALACRITTY_PATH" 2>/dev/null || true
        print_success "Terminal padrão configurado"
    fi

    # Entrada no menu
    if command -v alacritty &> /dev/null && [ ! -f ~/.local/share/applications/alacritty.desktop ]; then
        print_substep "Criando entrada no menu..."
        run_cmd mkdir -p ~/.local/share/applications
        if [ "$DRY_RUN" = false ]; then
            cat > ~/.local/share/applications/alacritty.desktop << EOF
[Desktop Entry]
Type=Application
Name=Alacritty
GenericName=Terminal
Comment=Terminal emulator
Exec=$(which alacritty)
Icon=utilities-terminal
Terminal=false
Categories=System;TerminalEmulator;
Keywords=terminal;shell;
EOF
            update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
        fi
        print_success "Entrada no menu criada"
    fi
}

# ============================================================================
# CONFIGURAÇÕES DO SISTEMA (macOS)
# ============================================================================

setup_macos_extras() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        return 0
    fi

    print_step "Configurações extras (macOS)..."

    # Verifica Homebrew
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew não encontrado!"
        echo "         Instale via: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi

    print_success "Homebrew OK"
}

# ============================================================================
# SUMÁRIO FINAL
# ============================================================================

print_summary() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}${BOLD}                    INSTALAÇÃO CONCLUÍDA!                      ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}Próximos passos:${NC}"
    echo ""
    echo "  1. Reinicie o terminal (ou abra o Alacritty)"
    echo ""
    echo "  2. Inicie o tmux:"
    echo -e "     ${CYAN}tmux${NC}"
    echo ""
    echo "  3. Veja o cheatsheet:"
    echo -e "     ${CYAN}Ctrl+a h${NC}"
    echo ""
    echo -e "${BOLD}Atalhos principais:${NC}"
    echo ""
    echo "  Alacritty:"
    echo "    Ctrl+V              Colar"
    echo "    Ctrl+Shift+F        Buscar"
    echo "    Ctrl+Shift+Space    Modo Vi (navegar)"
    echo ""
    echo "  tmux (prefixo: Ctrl+a):"
    echo "    Ctrl+a |            Dividir vertical"
    echo "    Ctrl+a -            Dividir horizontal"
    echo "    Ctrl+a h            Cheatsheet"
    echo "    Alt+setas           Navegar painéis"
    echo ""
    echo "  Vim (leader: Espaço):"
    echo "    Espaço+f            Buscar arquivos"
    echo "    Espaço+/            Buscar conteúdo"
    echo "    gcc                 Comentar linha"
    echo ""
    echo "  lazygit (TUI para Git):"
    echo "    lg                  Abrir lazygit (alias)"
    echo "    ?                   Mostrar atalhos"
    echo "    space               Stage/unstage arquivo"
    echo "    c                   Commit"
    echo "    p / P               Push / Pull"
    echo ""
    echo "  delta (diffs melhorados):"
    echo "    Side-by-side        Diff lado a lado"
    echo "    Line numbers        Clicáveis (abre no editor)"
    echo "    Syntax highlight    Colorização por linguagem"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Parse argumentos
    for arg in "$@"; do
        case $arg in
            --help|-h)
                print_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
        esac
    done

    print_header

    # Detecta sistema
    OS=$(detect_os)
    PKG_MANAGER=$(detect_pkg_manager)

    echo -e "  ${BOLD}Sistema:${NC}  $OS"
    echo -e "  ${BOLD}Pacotes:${NC}  $PKG_MANAGER"
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${BOLD}Modo:${NC}     ${YELLOW}dry-run (simulação)${NC}"
    fi
    echo ""

    # Instalação
    print_step "Instalando dependências..."
    install_if_missing "tmux" "tmux" "tmux"
    install_if_missing "vim" "Vim" "vim"
    install_if_missing "fzf" "fzf" "fzf"
    install_if_missing "rg" "ripgrep" "ripgrep" "ripgrep" "ripgrep" "ripgrep"

    if [[ "$OSTYPE" != "darwin"* ]]; then
        install_if_missing "xclip" "xclip" "xclip"
    fi

    install_font
    install_alacritty
    install_lazygit
    install_delta
    setup_symlinks
    setup_vim

    if [[ "$OSTYPE" == "darwin"* ]]; then
        setup_macos_extras
    else
        setup_linux_extras
    fi

    if [ "$DRY_RUN" = false ]; then
        print_summary
    else
        echo ""
        echo -e "${YELLOW}[dry-run] Simulação concluída. Nenhuma alteração foi feita.${NC}"
        echo ""
    fi
}

main "$@"
