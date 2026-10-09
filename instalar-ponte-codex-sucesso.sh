#!/usr/bin/env bash
# Configura Hermes com o provider oficial ChatGPT/Codex.
# Não importa tokens, chaves ou configurações de terceiros.
set -euo pipefail

MODEL="gpt-5.6-terra-900k"
PROVIDER="openai-codex"
BASE_URL="https://chatgpt.com/backend-api/codex"

if ! command -v hermes >/dev/null 2>&1; then
  echo "Hermes não encontrado. Instalando..."
  curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
fi

echo
printf '%s\n' "Hermes encontrado:"
hermes --version
echo
printf '%s\n' "Agora será aberto o login OAuth da SUA conta ChatGPT/Codex."
printf '%s\n' "Não cole senha, token ou chave neste script."

# --browser usa PKCE local quando houver navegador; o Hermes faz fallback
# para device-code se a porta de callback estiver indisponível.
hermes auth add "$PROVIDER" --type oauth --label "ChatGPT Codex pessoal" --browser

# A configuração fica limitada ao provider oficial, sem URL privada nem API key.
hermes config set model.provider "$PROVIDER"
hermes config set model.default "$MODEL"
hermes config set model.base_url "$BASE_URL"
hermes config set model.api_mode "codex_responses"

echo
echo "Validando a autenticação..."
hermes auth status "$PROVIDER"

echo
echo "Configuração concluída. Faça um teste real:"
echo '  hermes chat -q "Responda somente: ponte funcionando"'
