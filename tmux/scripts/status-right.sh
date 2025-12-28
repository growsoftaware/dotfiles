#!/bin/bash

# Cores Catppuccin Mocha
GREEN="#a6e3a1"
YELLOW="#f9e2af"
MAUVE="#cba6f7"
TEXT="#cdd6f4"
SUBTEXT="#a6adc8"

dir="$1"
output=""

cd "$dir" 2>/dev/null || exit

# Python venv (detecta se tem .venv ou venv no diretório)
if [ -d ".venv" ] || [ -d "venv" ]; then
    output+="#[fg=$GREEN] venv "
fi

# Git info
if git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2>/dev/null)

    status=""
    git diff --quiet 2>/dev/null || status+="*"
    git diff --cached --quiet 2>/dev/null || status+="+"
    [ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -1)" ] && status+="?"

    output+="#[fg=$MAUVE] $branch#[fg=$YELLOW]$status "
fi

# Hora
output+="#[fg=$SUBTEXT]%H:%M "

echo "$output"
