# Skill: iniciar sessão Claude Code remota no Quest 3 via SSH

Capacidade de disparar uma sessão do Claude Code rodando dentro do Termux
do Quest 3, a partir do PC — a direção contrária do que já funciona hoje
(Quest → PC, provado nas issues #5/#9). Sem isso, o modelo
planejador(PC)/aplicador(Quest) só funciona num sentido.

## Pré-requisito — issue #7 (status: **fechada, 2026-09-20**)

Resolvido. Dados reais da conexão:

- IP do Quest: `<ip-do-quest>` (DHCP — **pode mudar** a cada reboot/reconexão
  de rede; se o alias `quest3` parar de responder, essa é a primeira coisa a
  checar)
- Porta: `8022` (Termux não bind em porta <1024)
- Usuário Termux: `<usuario-termux>`
- Chave: `~/.ssh/id_ed25519_quest3_reverse`, registrada como alias SSH:
  ```
  Host quest3
    HostName <ip-do-quest>
    Port 8022
    User <usuario-termux>
    IdentityFile ~/.ssh/id_ed25519_quest3_reverse
    IdentitiesOnly yes
  ```
  Testado: `ssh quest3 whoami` → `<usuario-termux>`.
- **`sshd` do Termux não persiste entre reboots do Quest** — depois de
  restart do headset, precisa rodar `sshd` de novo lá dentro (ou configurar
  `sv-enable`/termux-services pra subir sozinho — decisão em aberto).

## Armadilha real já pega uma vez: versão global instável

O pacote global `@anthropic-ai/claude-code` no Termux **já voltou sozinho pra
2.1.278** (que exige binário nativo, inexistente pra Android/Bionic) depois
de ter sido fixado em `2.1.112` (JS puro, funciona). Sintoma: `claude
--version` responde `Error: claude native binary not installed`. Antes de
qualquer disparo remoto, se der esse erro, rodar de novo via SSH:
```bash
ssh quest3 "npm install -g @anthropic-ai/claude-code@2.1.112 --ignore-scripts --force"
```
Confirmado 2026-09-20: `claude --version` volta a responder `2.1.112 (Claude
Code)` normalmente, sem precisar de caminho completo nem alias — já resolve
em PATH puro numa sessão SSH não-interativa.

## Uso

**Disparo headless (uma tarefa, sem ficar interativo) — testado e confirmado 2026-09-20:**
```bash
ssh quest3 "claude --dangerously-skip-permissions -p '<prompt>'"
```
Teste real: prompt "reply with exactly: pong from quest via pc-initiated
ssh" devolveu exatamente isso. Independente de qualquer sessão interativa
(tipo a antiga "Opus 4.7") estar aberta ou não no Termux — isso dispara um
processo novo, executa e termina, é o padrão certo pra "manda instrução,
executa script, não fica esperando".

**Sessão interativa completa (retoma a sessão "quest3" existente):**
```bash
ssh -t quest3 claude --dangerously-skip-permissions --continue
```
O `-t` força alocação de TTY — sem ele, é o mesmo erro `/dev/tty: No such
device or address` já visto na direção contrária (issue #9). `--continue`
retoma o histórico da sessão em vez de começar do zero.

## Decisão registrada, não hardcoded por acidente

`--dangerously-skip-permissions` por padrão nos exemplos acima porque foi a
escolha explícita do Julio pra sessão local agora há pouco — mas isso
significa que uma sessão disparada remotamente executa qualquer ferramenta
sem pedir confirmação nenhuma, incluindo nova ação SSH de volta pro PC. Se
essa decisão mudar, atualizar aqui também — não é padrão "óbvio" o
suficiente pra ficar implícito só no comando.

**Direção Quest → PC também (2026-09-25):** o wrapper `claudepc`
(`shortcuts/claudepc.sh`) sempre inicia o Claude do PC com
`--dangerously-skip-permissions`, a pedido explícito do Julio. Consequência:
quem digita `claudepc` no Termux tem execução sem confirmação no PC
inteiro (arquivos, shell, SSH de volta pro Quest). A proteção passa a ser só
o acesso físico ao headset + a chave `id_ed25519_quest`. Testado: `claudepc
-p` criou arquivo no PC sem prompt de permissão.

## Controle do Termux a partir do PC (aprendido 2026-09-25)

O SSH no Quest entra como o mesmo usuário Android do app Termux, então o PC
tem controle total sobre o que roda **dentro do Termux** (não sobre outros
apps do Quest — sandbox do Android):

- **Ver/matar processos**, inclusive a aba visível na tela do Julio:
  `ssh quest3 'ps -eo pid,etime,tty,args'` e `kill <pid>`.
- **Abrir aba nova visível na tela** via intent `RUN_COMMAND` (exige
  `allow-external-apps = true` em `~/.termux/termux.properties`, já ativo):
  ```bash
  ssh quest3 claudepc-reabrir   # mata claudepc antigo + abre novo na frente
  ```
  Testado: a sessão Claude (bypass permissions) apareceu sozinha na tela.
- **Digitar numa aba já aberta: não dá** — Android bloqueia injeção de
  teclas em TTY de outra sessão. Por isso "sair" é matar o processo, não
  mandar `/exit`. Se precisar disso, rodar sessões dentro de `tmux` e usar
  `tmux send-keys` (ainda não configurado).
