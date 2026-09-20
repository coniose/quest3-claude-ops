# Task 001 — sair do beco sem saída do binário nativo, ir para PC-como-host

## Contexto

Sessão Claude Code rodando em Termux, dentro de um Meta Quest 3 (Android/Bionic,
aarch64). Objetivo do dia: parar de tentar rodar o Claude Code nativo local no
headset e virar um **cliente remoto fino** (SSH/mosh) para uma sessão do Claude
Code já rodando no PC/home lab do Julio.

## Por que parar de perseguir o binário nativo (decisão já tomada, não reabrir)

- A partir de `@anthropic-ai/claude-code@2.1.113` o CLI virou binário nativo.
- A Anthropic **não publica build para `linux-arm64-android` (Bionic)** — só
  `linux-arm64` (glibc) e `linux-arm64-musl`. Confirmado pelo próprio erro do
  `install.cjs`: `"Native binaries for linux-arm64-android are not available
  on this release channel."`
- Última versão só-JS que roda em Termux: `2.1.112` (166 versões atrás) — não
  vale manter como caminho principal.
- Rodar Claude Code nativo dentro do headset fica como **exploração separada,
  para depois** (branch própria, sem prioridade agora). Este repo é sobre o
  caminho principal: PC como host.

## Tarefa imediata (execute nesta ordem)

1. `pkg install openssh` (ou `mosh`, se a rede do Quest for instável —
   `pkg install mosh`). Não precisa de binário nativo do claude-code para
   isso, é pacote padrão do Termux.
2. Testar conexão SSH para o PC/home lab do Julio:
   - Se Quest e PC estiverem na **mesma rede Wi-Fi**: `ssh <usuario>@<IP-local-do-PC>`
     (peça o IP local ao Julio se não souber — `ipconfig` no PC Windows).
   - Se não estiverem na mesma rede: **pare aqui e reporte** — vai precisar de
     Tailscale ou outra malha remota, que ainda não foi configurada. Não tente
     configurar isso sozinho, é decisão de rede que o Julio precisa aprovar.
3. Depois de conectar por SSH, confirmar que dá para rodar `claude` normalmente
   do lado do PC (a sessão completa, Sonnet 5/Opus 5, sem as limitações de
   binário do Android).
4. Editar `STATUS.md` neste repo com o resultado de cada passo (feito / bloqueado
   / erro, com a mensagem exata), `git add`, `git commit`, `git push`.

## O que NÃO fazer

- Não retomar o downgrade para 2.1.112 nem testar mais versões via `npm view`.
- Não tentar proot/glibc-runner para rodar o binário nativo — fora de escopo
  desta tarefa.
- Não configurar VPN/malha remota (Tailscale etc.) sem o Julio decidir isso
  explicitamente primeiro.
