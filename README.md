# Dotfiles

Setup completo de terminal para desenvolvimento.

![Catppuccin Mocha](https://img.shields.io/badge/theme-Catppuccin%20Mocha-cba6f7?style=flat-square)
![Shell](https://img.shields.io/badge/shell-bash-89b4fa?style=flat-square)

## O que inclui

- **Alacritty** - Terminal GPU-accelerated com hints para URLs/paths
- **tmux** - Multiplexador com status bar (git, venv)
- **Vim** - Editor com plugins essenciais
- **JetBrains Mono** - Fonte inclusa no repo

**Tema:** Catppuccin Mocha em tudo

## Instalação Rápida

```bash
git clone https://github.com/SEU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Opções

```bash
./install.sh --help      # Ver ajuda
./install.sh --dry-run   # Simular sem instalar
```

## Compatibilidade

| Sistema | Gerenciador | Status |
|---------|-------------|--------|
| Ubuntu/Debian | apt | ✅ |
| Fedora | dnf | ✅ |
| Arch Linux | pacman | ✅ |
| macOS | Homebrew | ✅ |

## Atalhos Principais

### Alacritty
| Atalho | Função |
|--------|--------|
| `Ctrl+V` | Colar |
| `Ctrl+Shift+C` | Copiar |
| `Ctrl+Shift+F` | Buscar no output |
| `Ctrl+Shift+Space` | Vi mode (navegar) |
| `Ctrl+Shift+U` | URLs clicáveis |
| `Ctrl+Shift+O` | Abrir path no editor |

### tmux (prefix = Ctrl+a)
| Atalho | Função |
|--------|--------|
| `prefix h` | **Cheatsheet** |
| `prefix \|` | Dividir vertical |
| `prefix -` | Dividir horizontal |
| `prefix r` | Recarregar config |
| `prefix z` | Zoom no painel |
| `Alt+setas` | Navegar painéis |

### Vim (leader = Espaço)
| Atalho | Função |
|--------|--------|
| `leader w` | Salvar |
| `leader f` | Buscar arquivos |
| `leader /` | Buscar conteúdo |
| `leader b` | Listar buffers |
| `gcc` | Comentar linha |

## Estrutura

```
dotfiles/
├── alacritty/
│   └── alacritty.toml      # Config do terminal
├── tmux/
│   ├── .tmux.conf          # Config do tmux
│   └── scripts/
│       ├── cheatsheet.sh   # Menu de atalhos
│       └── status-right.sh # Git/venv na status bar
├── vim/
│   └── .vimrc              # Config do vim
├── fonts/
│   └── JetBrainsMono-*.ttf # Fonte inclusa
├── install.sh              # Instalador automático
└── README.md
```

## Personalização

### Trocar editor para paths (Alacritty)

Edite `~/.config/alacritty/alacritty.toml`:

```toml
# De (usa $EDITOR ou vim):
command = { program = "sh", args = ["-c", "${EDITOR:-vim} \"$0\""] }

# Para VS Code:
command = { program = "code", args = ["--goto"] }
```

### Variável EDITOR

Adicione ao seu `~/.bashrc` ou `~/.zshrc`:

```bash
export EDITOR=vim   # ou code, nvim, etc
```
