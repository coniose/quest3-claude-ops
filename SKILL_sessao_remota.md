# Skill: iniciar sessão Claude Code remota no Quest 3 via SSH

Capacidade de disparar uma sessão do Claude Code rodando dentro do Termux
do Quest 3, a partir do PC — a direção contrária do que já funciona hoje
(Quest → PC, provado nas issues #5/#9). Sem isso, o modelo
planejador(PC)/aplicador(Quest) só funciona num sentido.

## Pré-requisito — issue #7 (status: **aberta, sem resposta**)

- `sshd` rodando dentro do Termux (porta **8022** — Termux não tem
  permissão de bind em porta <1024).
- Minha chave pública (gerada nesta sessão) em
  `~/.ssh/authorized_keys` do Termux:
  ```
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGF1/8d7fOpQftENsIW1u+R0KvZRDwpqmjn8WUgl/YHD <hostname>-<usuario>-pc-to-quest3
  ```
- IP local do Quest (mesma rede `192.168.x.x`) e usuário Termux (`whoami`
  lá dentro).

Enquanto isso não fechar, os comandos abaixo não têm o que alcançar.

## Uso, uma vez destravado

**Disparo headless (uma tarefa, sem ficar interativo):**
```bash
ssh -p 8022 <usuario-termux>@<ip-quest> "claude --dangerously-skip-permissions -p '<prompt>'"
```

**Sessão interativa completa (retoma a sessão "quest3" existente):**
```bash
ssh -t -p 8022 <usuario-termux>@<ip-quest> claude --dangerously-skip-permissions --continue
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
