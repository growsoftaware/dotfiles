#!/bin/bash

# Catppuccin Mocha colors
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

TEXT='\033[38;2;205;214;244m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
MAUVE='\033[38;2;203;166;247m'
PINK='\033[38;2;245;194;231m'
TEAL='\033[38;2;148;226;213m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
PEACH='\033[38;2;250;179;135m'
OVERLAY='\033[38;2;108;112;134m'
SURFACE='\033[38;2;49;50;68m'

# Clipboard multiplataforma (macOS/Linux/WSL)
copy_to_clipboard() {
    if [[ "$(uname)" == "Darwin" ]]; then
        pbcopy
    elif grep -qi microsoft /proc/version 2>/dev/null; then
        clip.exe
    else
        xclip -selection clipboard 2>/dev/null || xsel --clipboard 2>/dev/null
    fi
}

get_all_shortcuts() {
    cat << 'EOF'
[Alacritty] Ctrl+Shift+C         Copia texto selecionado para clipboard do sistema
[Alacritty] Ctrl+V               Cola conteúdo do clipboard no terminal
[Alacritty] Ctrl++ / Ctrl+-      Aumenta ou diminui tamanho da fonte
[Alacritty] Ctrl+0               Volta fonte para tamanho original configurado
[Alacritty] Ctrl+Shift+N         Abre nova janela do Alacritty no mesmo diretório
[Alacritty] Ctrl+Shift+Space     Ativa Vi mode para navegar histórico com hjkl
[Alacritty] Ctrl+Shift+F         Abre busca interativa no output do terminal
[Alacritty] Ctrl+Shift+K         Limpa todo histórico de scrollback
[Alacritty] Ctrl+Shift+U         Destaca URLs clicáveis no output
[Alacritty] Ctrl+Shift+O         Abre arquivo/path sob cursor no VS Code
[Alacritty] Ctrl+Click           Abre link sob cursor no navegador padrão
[Tmux] prefix + |                Divide painel verticalmente (lado a lado)
[Tmux] prefix + -                Divide painel horizontalmente (um sobre outro)
[Tmux] prefix + a                Alterna rapidamente entre as duas últimas janelas
[Tmux] prefix + z                Maximiza painel atual (toggle zoom)
[Tmux] prefix + c                Cria nova janela na sessão atual
[Tmux] prefix + n                Vai para próxima janela na lista
[Tmux] Alt + setas               Navega entre painéis sem precisar do prefix
[Tmux] prefix + Escape           Entra no copy mode para selecionar e copiar texto
[Tmux] v (copy mode)             Inicia seleção visual do texto
[Tmux] y (copy mode)             Copia seleção para clipboard e sai do copy mode
[Tmux] hjkl (copy mode)          Move cursor caractere por caractere
[Tmux] Ctrl+u/d (copy mode)      Sobe/desce meia página no histórico
[Tmux] / ou ? (copy mode)        Busca texto para frente ou para trás
[Tmux] q (copy mode)             Sai do copy mode sem copiar nada
[Tmux] prefix + p                Abre shell temporário em popup flutuante
[Tmux] prefix + P                Pergunta comando e executa em popup flutuante
[Tmux] prefix + t                Abre scratch terminal persistente (pode virar pane)
[Tmux] prefix + h                Abre este cheatsheet em popup
[Tmux] prefix + J                Traz painel de outra janela para janela atual
[Tmux] prefix + S                Envia painel atual para outra janela
[Tmux] prefix + B                Transforma painel atual em janela independente
[Tmux] prefix + d                Desconecta da sessão (sessão continua rodando)
[Tmux] prefix + r                Recarrega arquivo de configuração do tmux
[Claude] claude                  Inicia nova conversa interativa com Claude
[Claude] claude -c               Continua última conversa do diretório atual
[Claude] claude -r               Continua conversa mais recente de qualquer lugar
[Claude] claude "prompt"         Envia prompt direto e entra em modo interativo
[Claude] claude -p "prompt"      Executa prompt e retorna resposta (não interativo)
[Claude] cat file | claude       Envia conteúdo de arquivo como contexto
[Claude] /help                   Mostra ajuda com comandos disponíveis
[Claude] /clear                  Limpa contexto da conversa atual
[Claude] /compact                Compacta histórico para economizar tokens
[Claude] /config                 Abre menu de configurações do Claude
[Claude] /cost                   Mostra custo em tokens/dinheiro da sessão
[Claude] /doctor                 Executa diagnóstico de problemas
[Claude] /quit ou Ctrl+C         Encerra sessão atual do Claude
[Vim] leader + w                 Salva arquivo atual (:w)
[Vim] leader + q                 Fecha janela/buffer atual (:q)
[Vim] leader + f                 Abre fuzzy finder para buscar arquivos
[Vim] leader + /                 Busca texto em todo projeto com ripgrep
[Vim] leader + b                 Lista buffers abertos para navegação
[Vim] Esc                        Limpa highlight da última busca
[Vim] gcc                        Comenta/descomenta linha atual
[Vim] gc{motion}                 Comenta região (gcap = parágrafo, gcG = até fim)
[Vim] cs'"                       Troca aspas simples por duplas (surround)
[Vim] ds"                        Remove aspas ao redor do texto
[Vim] ysiw"                      Adiciona aspas ao redor da palavra atual
[Vim] Ctrl+o / Ctrl+i            Navega posições anteriores/próximas no jumplist
[Vim] gd                         Vai para definição do símbolo sob cursor
[Vim] *                          Busca próxima ocorrência da palavra sob cursor
[Vim] %                          Pula entre parênteses/chaves/colchetes
EOF
}

show_search() {
    local result
    result=$(get_all_shortcuts | fzf \
        --ansi \
        --reverse \
        --border=rounded \
        --border-label=" 🔍 Buscar Atalhos " \
        --header="Digite para filtrar • Enter para copiar • Esc para voltar" \
        --prompt="❯ " \
        --pointer="▶" \
        --color="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#89b4fa,label:#89b4fa" \
        --margin=1 \
        --padding=1)

    if [[ -n "$result" ]]; then
        echo "$result" | copy_to_clipboard
    fi
}

show_menu() {
    clear
    echo -e "${BLUE}${BOLD}  ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮${RESET}
${BLUE}${BOLD}  │${RESET}${LAVENDER}${BOLD}                                            CHEATSHEET                                              ${RESET}${BLUE}${BOLD}│${RESET}
${BLUE}${BOLD}  ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯${RESET}

          ${MAUVE}${BOLD}[1]${RESET} ${TEXT}Alacritty${RESET}  ${DIM}─ atalhos do terminal${RESET}              ${MAUVE}${BOLD}[3]${RESET} ${TEXT}Claude CLI${RESET}  ${DIM}─ comandos e slash commands${RESET}
          ${MAUVE}${BOLD}[2]${RESET} ${TEXT}Tmux${RESET}       ${DIM}─ painéis, janelas, copy mode${RESET}       ${MAUVE}${BOLD}[4]${RESET} ${TEXT}Vim${RESET}        ${DIM}─ edição, navegação, plugins${RESET}

${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}

          ${YELLOW}${BOLD}[/]${RESET} ${TEXT}Buscar em todos os atalhos${RESET}                    ${DIM}${OVERLAY}[q] Fechar${RESET}
"
}

show_alacritty() {
    clear
    echo -e "${TEAL}${BOLD}  ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮${RESET}
${TEAL}${BOLD}  │${RESET}${TEXT}${BOLD}                                            ALACRITTY                                               ${RESET}${TEAL}${BOLD}│${RESET}
${TEAL}${BOLD}  ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯${RESET}

${YELLOW}  Clipboard e Janela${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}Ctrl+Shift+C${RESET}        ${TEXT}Copia texto selecionado para clipboard do sistema${RESET}
   ${GREEN}Ctrl+V${RESET}              ${TEXT}Cola conteúdo do clipboard no terminal${RESET}
   ${GREEN}Ctrl++ / Ctrl+-${RESET}     ${TEXT}Aumenta ou diminui tamanho da fonte${RESET}
   ${GREEN}Ctrl+0${RESET}              ${TEXT}Volta fonte para tamanho original configurado${RESET}
   ${GREEN}Ctrl+Shift+N${RESET}        ${TEXT}Abre nova janela do Alacritty no mesmo diretório${RESET}

${YELLOW}  Navegação e Histórico${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}Ctrl+Shift+Space${RESET}    ${TEXT}Ativa Vi mode para navegar histórico com hjkl, buscar com /, selecionar com v${RESET}
   ${GREEN}Ctrl+Shift+F${RESET}        ${TEXT}Abre busca interativa no output do terminal${RESET}
   ${GREEN}Ctrl+Shift+K${RESET}        ${TEXT}Limpa todo histórico de scrollback${RESET}

${YELLOW}  Integração com Sistema${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}Ctrl+Shift+U${RESET}        ${TEXT}Destaca URLs clicáveis no output - navega com Tab, abre com Enter${RESET}
   ${GREEN}Ctrl+Shift+O${RESET}        ${TEXT}Abre arquivo ou path sob cursor no VS Code${RESET}
   ${GREEN}Ctrl+Click${RESET}          ${TEXT}Abre link sob cursor diretamente no navegador padrão${RESET}

${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${DIM}${OVERLAY}[b] Voltar       [/] Buscar       [Esc] Vim mode       [q] Fechar${RESET}"
}

show_tmux() {
    clear
    echo -e "${MAUVE}${BOLD}  ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮${RESET}
${MAUVE}${BOLD}  │${RESET}${TEXT}${BOLD}                                      TMUX  ${DIM}(prefix = Ctrl+a)                                       ${RESET}${MAUVE}${BOLD}│${RESET}
${MAUVE}${BOLD}  ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯${RESET}

${YELLOW}  Janelas e Painéis${RESET}                                  ${YELLOW}Copy Mode ${DIM}(selecionar/copiar texto)${RESET}
${OVERLAY}  ─────────────────────────────────────────────────     ─────────────────────────────────────────────────${RESET}
   ${GREEN}prefix + |${RESET}      ${TEXT}Divide vertical (lado a lado)${RESET}        ${GREEN}prefix + Esc${RESET}  ${TEXT}Entra no copy mode${RESET}
   ${GREEN}prefix + -${RESET}      ${TEXT}Divide horizontal (um sobre outro)${RESET}   ${GREEN}v${RESET}             ${TEXT}Inicia seleção visual${RESET}
   ${GREEN}prefix + a${RESET}      ${TEXT}Alterna entre últimas janelas${RESET}        ${GREEN}y${RESET}             ${TEXT}Copia seleção pro clipboard${RESET}
   ${GREEN}prefix + z${RESET}      ${TEXT}Zoom toggle no painel atual${RESET}          ${GREEN}hjkl${RESET}          ${TEXT}Move cursor${RESET}
   ${GREEN}prefix + c${RESET}      ${TEXT}Cria nova janela${RESET}                     ${GREEN}Ctrl+u/d${RESET}      ${TEXT}Page up/down${RESET}
   ${GREEN}prefix + n${RESET}      ${TEXT}Próxima janela${RESET}                       ${GREEN}/ ou ?${RESET}        ${TEXT}Busca frente/trás${RESET}
   ${GREEN}Alt+setas${RESET}       ${TEXT}Navega painéis sem prefix${RESET}            ${GREEN}q${RESET}             ${TEXT}Sai do copy mode${RESET}

${YELLOW}  Popups Flutuantes${RESET}                                  ${YELLOW}Reorganizar Painéis${RESET}
${OVERLAY}  ─────────────────────────────────────────────────     ─────────────────────────────────────────────────${RESET}
   ${GREEN}prefix + p${RESET}      ${TEXT}Shell temporário em popup${RESET}            ${GREEN}prefix + J${RESET}    ${TEXT}Traz pane de outra janela${RESET}
   ${GREEN}prefix + P${RESET}      ${TEXT}Executa comando em popup${RESET}             ${GREEN}prefix + S${RESET}    ${TEXT}Envia pane pra outra janela${RESET}
   ${GREEN}prefix + t${RESET}      ${TEXT}Scratch terminal persistente${RESET}         ${GREEN}prefix + B${RESET}    ${TEXT}Pane vira janela independente${RESET}
   ${GREEN}prefix + h${RESET}      ${TEXT}Abre este cheatsheet${RESET}

${YELLOW}  Sessão${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}prefix + d${RESET}      ${TEXT}Desconecta da sessão (continua em background)${RESET}
   ${GREEN}prefix + r${RESET}      ${TEXT}Recarrega ~/.tmux.conf${RESET}

${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${DIM}${OVERLAY}[b] Voltar       [/] Buscar       [Esc] Vim mode       [q] Fechar${RESET}"
}

show_claude() {
    clear
    echo -e "${PINK}${BOLD}  ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮${RESET}
${PINK}${BOLD}  │${RESET}${TEXT}${BOLD}                                           CLAUDE CLI                                              ${RESET}${PINK}${BOLD}│${RESET}
${PINK}${BOLD}  ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯${RESET}

${YELLOW}  Iniciando Conversas${RESET}                                ${YELLOW}Slash Commands ${DIM}(dentro da conversa)${RESET}
${OVERLAY}  ─────────────────────────────────────────────────     ─────────────────────────────────────────────────${RESET}
   ${GREEN}claude${RESET}              ${TEXT}Nova conversa interativa${RESET}         ${GREEN}/help${RESET}           ${TEXT}Mostra ajuda completa${RESET}
   ${GREEN}claude -c${RESET}           ${TEXT}Continua última do diretório${RESET}     ${GREEN}/clear${RESET}          ${TEXT}Limpa contexto da conversa${RESET}
   ${GREEN}claude -r${RESET}           ${TEXT}Continua mais recente${RESET}            ${GREEN}/compact${RESET}        ${TEXT}Compacta histórico${RESET}
   ${GREEN}claude \"prompt\"${RESET}     ${TEXT}Prompt direto + interativo${RESET}      ${GREEN}/config${RESET}         ${TEXT}Menu de configurações${RESET}
   ${GREEN}claude -p \"...\"${RESET}    ${TEXT}Executa e retorna (scripts)${RESET}      ${GREEN}/cost${RESET}           ${TEXT}Custo em tokens/dinheiro${RESET}
   ${GREEN}cat f | claude${RESET}      ${TEXT}Arquivo como contexto${RESET}            ${GREEN}/doctor${RESET}         ${TEXT}Diagnóstico de problemas${RESET}
                                                       ${GREEN}/quit${RESET}           ${TEXT}Encerra sessão${RESET}

${YELLOW}  Dicas de Uso com Alacritty${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}Ctrl+Shift+Space${RESET}    ${TEXT}Vi mode pra navegar outputs longos${RESET}
   ${GREEN}Ctrl+Shift+F${RESET}        ${TEXT}Busca texto nas respostas${RESET}
   ${GREEN}Ctrl+Shift+U${RESET}        ${TEXT}Destaca URLs clicáveis${RESET}

${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${DIM}${OVERLAY}[b] Voltar       [/] Buscar       [Esc] Vim mode       [q] Fechar${RESET}"
}

show_vim() {
    clear
    echo -e "${PEACH}${BOLD}  ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮${RESET}
${PEACH}${BOLD}  │${RESET}${TEXT}${BOLD}                                        VIM  ${DIM}(leader = Espaço)                                       ${RESET}${PEACH}${BOLD}│${RESET}
${PEACH}${BOLD}  ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯${RESET}

${YELLOW}  Comandos Básicos${RESET}                                   ${YELLOW}Plugins - Comentários e Surround${RESET}
${OVERLAY}  ─────────────────────────────────────────────────     ─────────────────────────────────────────────────${RESET}
   ${GREEN}leader + w${RESET}        ${TEXT}Salva arquivo (:w)${RESET}                 ${GREEN}gcc${RESET}             ${TEXT}Comenta/descomenta linha${RESET}
   ${GREEN}leader + q${RESET}        ${TEXT}Fecha janela/buffer (:q)${RESET}           ${GREEN}gc{motion}${RESET}      ${TEXT}Comenta região (gcap, gcG)${RESET}
   ${GREEN}leader + f${RESET}        ${TEXT}Fuzzy finder de arquivos${RESET}           ${GREEN}cs'\"${RESET}            ${TEXT}Troca ' por \" (surround)${RESET}
   ${GREEN}leader + /${RESET}        ${TEXT}Busca no projeto (ripgrep)${RESET}         ${GREEN}ds\"${RESET}             ${TEXT}Remove aspas${RESET}
   ${GREEN}leader + b${RESET}        ${TEXT}Lista buffers abertos${RESET}              ${GREEN}ysiw\"${RESET}           ${TEXT}Adiciona \" na palavra${RESET}
   ${GREEN}Esc${RESET}               ${TEXT}Limpa highlight da busca${RESET}

${YELLOW}  Navegação${RESET}
${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${GREEN}Ctrl+o${RESET}            ${TEXT}Volta posição anterior no jumplist${RESET}
   ${GREEN}Ctrl+i${RESET}            ${TEXT}Avança posição no jumplist${RESET}
   ${GREEN}gd${RESET}                ${TEXT}Vai para definição (LSP)${RESET}
   ${GREEN}*${RESET}                 ${TEXT}Busca palavra sob cursor${RESET}
   ${GREEN}%${RESET}                 ${TEXT}Pula entre parênteses/chaves${RESET}

${OVERLAY}  ──────────────────────────────────────────────────────────────────────────────────────────────────────${RESET}
   ${DIM}${OVERLAY}[b] Voltar       [/] Buscar       [Esc] Vim mode       [q] Fechar${RESET}"
}

handle_section() {
    local show_func="$1"
    while true; do
        $show_func
        read -n 1 -s key
        case $key in
            b) return ;;
            q) exit 0 ;;
            /) show_search ;;
            $'\e') # Escape - vim mode com less
                $show_func 2>&1 | less -R --no-init --quit-if-one-screen +G
                ;;
        esac
    done
}

while true; do
    show_menu
    read -n 1 -s key
    case $key in
        1) handle_section show_alacritty ;;
        2) handle_section show_tmux ;;
        3) handle_section show_claude ;;
        4) handle_section show_vim ;;
        /) show_search ;;
        q) exit 0 ;;
    esac
done
