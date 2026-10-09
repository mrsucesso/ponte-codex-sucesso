# Ponte Codex Sucesso — instrução pronta para o agente

Copie e envie este texto para o agente dele:

---

Quero configurar o Hermes para usar **a minha própria conta ChatGPT/Codex** como modelo, usando o provider oficial `openai-codex` — sem API key e sem importar credenciais de ninguém.

## Regras obrigatórias

- Não peça, não leia e não copie senha, token OAuth, `auth.json`, `.env` ou chaves de API de outra pessoa.
- Não configure endpoint privado, proxy de terceiros ou porta pública.
- Use apenas OAuth oficial da minha conta, executado localmente neste ambiente.
- Antes de alterar, mostre `hermes --version`, `hermes config path` e `hermes auth add --help`.
- Se Hermes não estiver instalado, instale pelo instalador oficial:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
  ```
- Rode o login oficial:
  ```bash
  hermes auth add openai-codex --type oauth --label "ChatGPT Codex pessoal" --browser
  ```
  Se a máquina não tiver navegador, siga o fluxo device-code exibido pelo Hermes. Eu concluo a autorização no navegador usando a minha conta.
- Depois que o OAuth terminar com sucesso, configure explicitamente:
  ```bash
  hermes config set model.provider openai-codex
  hermes config set model.default gpt-5.6-terra-900k
  hermes config set model.base_url https://chatgpt.com/backend-api/codex
  hermes config set model.api_mode codex_responses
  ```
- Verifique, sem revelar valores sensíveis:
  ```bash
  hermes auth status openai-codex
  hermes config
  hermes chat -q "Responda somente: ponte funcionando"
  ```
- Informe o resultado real do teste. Se o modelo acima não estiver disponível na minha conta, use `hermes model` para escolher um modelo Codex disponível e informe qual foi selecionado.

Não faça gateway, Telegram, Docker, CLIProxyAPI, Cloudflare ou qualquer exposição de rede. O objetivo é somente o Hermes local usando minha assinatura, de forma isolada.

---

## Nota técnica

O login OAuth pertence ao usuário que conclui a autorização. O modelo é só uma configuração reutilizável; o acesso nunca deve ser transportado de uma pessoa para outra.
