#!/data/data/com.termux/files/usr/bin/bash
# Instala o Claude Code no Termux (Android)
set -e

echo "==> [1/5] Atualizando pacotes..."
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo "==> [2/5] Instalando Node.js, Git e ripgrep..."
pkg install -y nodejs git ripgrep

echo "==> [3/5] Liberando acesso aos arquivos do celular..."
if [ ! -d "$HOME/storage/shared" ]; then
  termux-setup-storage
  echo "    Aceite a permissão na tela do Android..."
  for i in $(seq 1 60); do
    [ -d "$HOME/storage/shared" ] && break
    sleep 1
  done
fi
if [ -d "$HOME/storage/shared" ]; then
  echo "    OK: arquivos em ~/storage/shared"
else
  echo "    AVISO: permissão não concedida. Rode 'termux-setup-storage' depois."
fi

echo "==> [4/5] Instalando o Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "==> [5/5] Ajustando configuração..."
grep -q 'USE_BUILTIN_RIPGREP' "$HOME/.bashrc" 2>/dev/null || \
  echo 'export USE_BUILTIN_RIPGREP=0' >> "$HOME/.bashrc"
grep -q 'alias celular=' "$HOME/.bashrc" 2>/dev/null || \
  echo 'alias celular="cd ~/storage/shared"' >> "$HOME/.bashrc"

echo ""
echo "Pronto! Versão instalada: $(claude --version 2>/dev/null || echo '?')"
echo ""
echo "Para usar:"
echo "  source ~/.bashrc"
echo "  celular            # vai para a memória interna"
echo "  cd Documents       # ou a pasta que quiser"
echo "  claude             # inicia (1ª vez pede login)"
