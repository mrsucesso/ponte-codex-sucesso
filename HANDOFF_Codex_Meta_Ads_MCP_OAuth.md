# Handoff — OAuth Meta Ads MCP no Codex Windows

## Causa do bloqueio

A Meta está com **Force HTTPS** ligado e o controle desabilitado (padrão de apps novos desde 2018).

O Codex inicia OAuth com redirect loopback:

```text
http://127.0.0.1:<porta>/callback/<id>
```

A Meta recusa esse `redirect_uri` HTTP com a mensagem de “conexão não segura”.

Referência oficial Meta (Login Security):
- Enforce HTTPS exige HTTPS nos OAuth Redirects
- Strict Mode exige match exato do redirect URI
- Não mexer no app ZapSim Waba API

## Solução montada (já no ar)

Ponte HTTPS isolada em subdomínio novo do `mais.top` (não mexe em outros hosts):

```text
https://meta-ads-oauth.mais.top
```

Comportamento:
1. Meta redireciona o browser para `https://meta-ads-oauth.mais.top/callback/<id>?code=...&state=...`
2. O Worker devolve HTML que manda o browser para `http://127.0.0.1:18787/callback/<id>?code=...&state=...`
3. O listener local do Codex recebe `code` + `state` e completa PKCE/token exchange

Validado:
- `GET https://meta-ads-oauth.mais.top/` → 200
- `GET https://meta-ads-oauth.mais.top/callback/test?code=abc&state=xyz` → HTML hop para `http://127.0.0.1:18787/...`

Infra criada:
- Worker Cloudflare: `meta-ads-oauth-bridge`
- DNS proxied: `meta-ads-oauth.mais.top` (AAAA `100::`)
- Route: `meta-ads-oauth.mais.top/*` → worker
- Porta local fixa do hop: **18787**

## Configuração Meta (app 1448817660693150)

App: **Sucesso Ads MCP**  
Business Login settings:  
https://developers.facebook.com/apps/1448817660693150/business-login/settings/?business_id=153804325004340

Manter:
- OAuth do cliente: ON
- OAuth na Web: ON
- Force HTTPS: ON (não dá para desligar)
- Strict Mode: ON

Em **Valid OAuth Redirect URIs**, remover os `http://127.0.0.1...` antigos e cadastrar **exatamente**:

```text
https://meta-ads-oauth.mais.top/callback/p3oJPar44nR2
```

Se o Codex gerar outro id de path no próximo login, cadastre também o URI exato novo (Strict Mode exige match total).  
Opcional de backup:

```text
https://meta-ads-oauth.mais.top/oauth/callback
```

**Não** use wildcard. **Não** reutilize state/code/challenge antigos.

## Configuração Codex (Windows)

Arquivo: `%USERPROFILE%\.codex\config.toml`

Adicionar/ajustar:

```toml
# porta fixa do listener OAuth MCP
mcp_oauth_callback_port = 18787

# URL pública HTTPS anunciada à Meta (a ponte faz hop para 127.0.0.1:18787)
mcp_oauth_callback_url = "https://meta-ads-oauth.mais.top"
```

Servidor MCP (se ainda não estiver):

```toml
[mcp_servers.meta-ads]
url = "https://mcp.facebook.com/ads"

[mcp_servers.meta-ads.oauth]
client_id = "1448817660693150"
callback_url = "https://meta-ads-oauth.mais.top"
callback_port = 18787
```

Ou via CLI:

```bat
codex mcp remove meta-ads
codex mcp add meta-ads --url https://mcp.facebook.com/ads --oauth-client-id 1448817660693150
```

Depois confira se o `config.toml` ficou com `callback_url/port` como acima.

## Execução OAuth (fluxo limpo)

1. Feche tentativas OAuth antigas no Codex.
2. Confirme Meta redirect URI HTTPS cadastrado.
3. No Windows:

```bat
codex mcp login meta-ads
```

Se preferir controle manual da URL:

```bat
codex mcp login meta-ads --no-browser
```

4. Abra a URL gerada **no navegador integrado do Codex** (sessão Meta já autenticada).
5. Autorize o app.
6. O browser deve passar por `https://meta-ads-oauth.mais.top/...` e cair em `http://127.0.0.1:18787/callback/...`.
7. Codex deve gravar credenciais e marcar Auth OK.

Se a Meta reclamar de redirect mismatch:
- copie o `redirect_uri=` da URL de authorize gerada pelo Codex
- cadastre **exatamente** esse valor em Valid OAuth Redirect URIs
- rode `codex mcp login meta-ads` de novo (fluxo novo; não reaproveitar code)

## Validação de conclusão

Depois do login:

```bat
codex mcp list
```

`meta-ads` deve aparecer autenticado.

Consulta somente leitura (via Codex / MCP tools do servidor Meta Ads), listando ad accounts acessíveis. Exemplos de intenção:

- listar ad accounts do usuário/BM
- confirmar IDs sem criar campanha, sem gastar, sem mudar status

Critério de pronto:
1. OAuth concluído e credencial armazenada pelo Codex
2. Listagem read-only de contas de anúncios OK

## Segurança / escopo

- Não alterar app **ZapSim Waba API**
- Não expor App Secret no chat
- Não desligar Force HTTPS / Strict Mode
- Subdomínio novo isolado: `meta-ads-oauth.mais.top` (não mexe em mcp.mais.top nem outros)
- Ponte só faz hop browser-side para loopback; não armazena tokens
- Sem recursos pagos novos

## Troubleshooting rápido

| Sintoma | Ação |
|---|---|
| Meta ainda fala conexão insegura | A URL authorize ainda tem `http://127.0.0.1` — falta `mcp_oauth_callback_url` HTTPS no config |
| redirect_uri mismatch | Cadastrar o URI exato da authorize URL na Meta |
| Bridge abre mas Codex não recebe | Conferir se login está escutando porta **18787** |
| Porta diferente | Ajustar Worker (LOCAL_PORT) e config para a mesma porta |
| App não publicado | Em dev, login costuma funcionar para admins/testers do app; se bloquear, adicionar `mauricio@sucesso.com.br` como admin/tester |

## Contatos / IDs

- App ID: `1448817660693150`
- BM: `153804325004340` (BM - Sucesso Empresarial)
- Contato: `mauricio@sucesso.com.br`
- MCP: `https://mcp.facebook.com/ads`
- Bridge: `https://meta-ads-oauth.mais.top`
