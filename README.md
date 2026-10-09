# Ponte Codex Sucesso

Este pacote entrega o caminho **oficial e portátil** para o seu amigo usar a própria assinatura ChatGPT/Codex no Hermes.

Ele **não contém**: senhas, tokens OAuth, chaves de API, `auth.json`, `.env`, histórico, sessões, configuração de Telegram, URLs internas, ou qualquer acesso ao seu servidor.

## O que é entregue

- Provider Hermes: `openai-codex`
- Modelo-padrão sugerido: `gpt-5.6-terra-900k`
- Base oficial: `https://chatgpt.com/backend-api/codex`
- Modo da API: `codex_responses`
- Login: OAuth da própria conta ChatGPT do usuário

## O que o amigo precisa

1. Linux, macOS ou WSL.
2. Uma conta ChatGPT que tenha acesso ao Codex.
3. Navegador aberto na conta que ele quer vincular.

> Isso não transfere sua cota, nem compartilha sua conta. Cada pessoa autentica a própria conta e assume os próprios limites de uso.

## Instalação rápida

Na pasta deste pacote:

```bash
chmod +x instalar-ponte-codex-sucesso.sh
./instalar-ponte-codex-sucesso.sh
```

O script instala o Hermes caso ele não exista, abre o fluxo OAuth oficial e configura o provider/modelo.

## Conferência após instalar

```bash
hermes auth status openai-codex
hermes config
hermes chat -q "Responda somente: ponte funcionando"
```

Se o login ocorrer numa máquina remota sem navegador, rode o mesmo script no terminal interativo. Ele mostrará um fluxo de autorização por dispositivo; conclua no navegador com a conta correta.

## Não copiar estes arquivos

Nunca envie para outra pessoa:

```text
~/.hermes/auth.json
~/.codex/auth.json
~/.hermes/.env
~/.hermes/config.yaml inteiro
```

Eles podem carregar credenciais, URLs privadas, integrações e dados pessoais.

## Alternativa: endpoint OpenAI-compatible para outros apps

O Hermes acima não precisa de proxy. Para expor uma API OpenAI-compatible a outros aplicativos, o amigo deve criar uma ponte **isolada no próprio servidor**, com OAuth da própria conta e acesso apenas por loopback/rede privada. Não use a ponte de outra pessoa, não copie JSON OAuth e não exponha a porta na internet.

A instrução completa para o agente dele está em `INSTRUCAO-PARA-O-AGENTE.md`.

## Licença

[MIT](LICENSE).
