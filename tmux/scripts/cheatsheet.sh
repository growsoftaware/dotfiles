#!/bin/bash

show_menu() {
    clear
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│                    CHEATSHEET                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│     [1] Alacritty + tmux                                    │
│                                                             │
│     [2] Claude CLI                                          │
│                                                             │
│     [3] Vim                                                 │
│                                                             │
│     [q] Fechar                                              │
│                                                             │
╰─────────────────────────────────────────────────────────────╯
EOF
}

show_alacritty() {
    clear
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│  [1] ALACRITTY + TMUX                                       │
├─────────────────────────────────────────────────────────────┤
│  ALACRITTY                                                  │
│  ─────────                                                  │
│  Ctrl+V              Colar                                  │
│  Ctrl+Shift+C        Copiar                                 │
│  Ctrl++ / Ctrl+-     Zoom fonte                             │
│  Ctrl+0              Reset zoom                             │
│  Ctrl+Shift+F        Buscar no output                       │
│  Ctrl+Shift+Space    Vi mode (navegar com hjkl)             │
│  Ctrl+Shift+K        Limpar histórico                       │
│  Ctrl+Shift+U        Mostrar URLs clicáveis                 │
│  Ctrl+Shift+O        Abrir path no VS Code                  │
│  Ctrl+Shift+N        Nova janela                            │
│  Ctrl+Click          Abrir URL no navegador                 │
├─────────────────────────────────────────────────────────────┤
│  TMUX (prefix = Ctrl+a)                                     │
│  ─────────────────────                                      │
│  prefix + |          Dividir vertical                       │
│  prefix + -          Dividir horizontal                     │
│  prefix + h          Cheatsheet (este popup)                │
│  prefix + r          Recarregar config                      │
│  prefix + z          Zoom no painel atual                   │
│  prefix + d          Desconectar sessão                     │
│  prefix + c          Nova janela                            │
│  prefix + n/p        Próxima/anterior janela                │
│  prefix + [          Modo cópia (q pra sair)                │
│  Alt + setas         Navegar painéis                        │
╰─────────────────────────────────────────────────────────────╯
              [b] Voltar    [q] Fechar
EOF
}

show_claude() {
    clear
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│  [2] CLAUDE CLI                                             │
├─────────────────────────────────────────────────────────────┤
│  COMANDOS                                                   │
│  ────────                                                   │
│  claude                Iniciar conversa                     │
│  claude -c             Continuar última conversa            │
│  claude -r             Continuar mais recente               │
│  claude "prompt"       Prompt direto                        │
│  claude -p "prompt"    Modo print (sem interativo)          │
│  cat file | claude     Pipe de arquivo                      │
├─────────────────────────────────────────────────────────────┤
│  DENTRO DA CONVERSA                                         │
│  ──────────────────                                         │
│  /help                 Ajuda                                │
│  /clear                Limpar contexto                      │
│  /compact              Compactar histórico                  │
│  /config               Configurações                        │
│  /cost                 Ver custo da sessão                  │
│  /doctor               Diagnóstico                          │
│  /quit ou Ctrl+C       Sair                                 │
├─────────────────────────────────────────────────────────────┤
│  ATALHOS NO ALACRITTY (úteis com Claude)                    │
│  ───────────────────────────────────────                    │
│  Ctrl+Shift+Space      Vi mode - navegar output longo       │
│  Ctrl+Shift+F          Buscar no output                     │
│  Ctrl+Shift+U          Clicar em URLs do output             │
│  Ctrl+Shift+O          Abrir paths no VS Code               │
│  Scroll: 50k linhas    Histórico grande pra outputs         │
╰─────────────────────────────────────────────────────────────╯
              [b] Voltar    [q] Fechar
EOF
}

show_vim() {
    clear
    cat << 'EOF'
╭─────────────────────────────────────────────────────────────╮
│  [3] VIM                                                    │
├─────────────────────────────────────────────────────────────┤
│  BÁSICO (leader = Espaço)                                   │
│  ────────────────────────                                   │
│  leader + w          Salvar (:w)                            │
│  leader + q          Fechar (:q)                            │
│  leader + f          Buscar arquivos (fzf)                  │
│  leader + /          Buscar conteúdo (rg)                   │
│  leader + b          Listar buffers                         │
│  Esc                 Limpar highlight da busca              │
├─────────────────────────────────────────────────────────────┤
│  PLUGINS                                                    │
│  ───────                                                    │
│  gcc                 Comentar/descomentar linha             │
│  gc{motion}          Comentar região (ex: gcap)             │
│  cs'"                Trocar ' por " (surround)              │
│  ds"                 Deletar aspas                          │
│  ysiw"               Adicionar " em volta da palavra        │
├─────────────────────────────────────────────────────────────┤
│  NAVEGAÇÃO                                                  │
│  ─────────                                                  │
│  Ctrl+o / Ctrl+i     Voltar / avançar posição               │
│  gd                  Ir para definição                      │
│  *                   Buscar palavra sob cursor              │
│  %                   Ir para bracket correspondente         │
╰─────────────────────────────────────────────────────────────╯
              [b] Voltar    [q] Fechar
EOF
}

while true; do
    show_menu
    read -n 1 -s key
    case $key in
        1)
            while true; do
                show_alacritty
                read -n 1 -s key
                [[ $key == "b" ]] && break
                [[ $key == "q" ]] && exit 0
            done
            ;;
        2)
            while true; do
                show_claude
                read -n 1 -s key
                [[ $key == "b" ]] && break
                [[ $key == "q" ]] && exit 0
            done
            ;;
        3)
            while true; do
                show_vim
                read -n 1 -s key
                [[ $key == "b" ]] && break
                [[ $key == "q" ]] && exit 0
            done
            ;;
        q)
            exit 0
            ;;
    esac
done
