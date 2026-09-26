# Status

Preencha aqui o resultado de cada passo do TASK.md — feito / bloqueado / erro,
com a mensagem exata quando houver. Commit e push a cada atualização.

## Task 001

- [x] `pkg install openssh`/`mosh`
  - Feito 2026-09-20. `openssh` já estava instalado na versão mais nova do repo
    Termux: `openssh is already the newest version (10.5p1). 0 upgraded, 0
    newly installed`. Cliente `ssh` disponível: `OpenSSH_10.5p1, OpenSSL 3.6.3`.
    Não instalei `mosh` — só se a rede se mostrar instável no passo 2.
- [x] Teste de conexão SSH ao PC/home lab — **funciona** após Julio rodar
      PowerShell elevado (issue #4). `ssh <usuario>@<ip-do-pc> whoami` retorna
      `<hostname>\<usuario>`, hostname `<HOSTNAME>`, com pubkey ed25519.
  - Alvo: `<usuario>@<ip-do-pc>` (dados vieram do PR #2 do PC, seção abaixo).
  - Rede: `ping` bloqueado (esperado — firewall Windows não libera ICMP), mas
    TCP:22 responde e banner é `SSH-2.0-OpenSSH_for_Windows_10.0
    Win32-OpenSSH-GitHub`. Ou seja: **rota + porta 22 + sshd todos OK**.
  - Auth: sessão Termux não tem como digitar senha interativamente. Gerei par
    ed25519 local (`~/.ssh/id_ed25519_quest`, sem passphrase). Bloqueio ativo
    → **issue #3**: PC não conseguiu escrever em
    `C:\ProgramData\ssh\administrators_authorized_keys` (shell dele sem admin);
    pediu ao Julio rodar o bloco PowerShell **em janela elevada**. Testado
    daqui: `ssh -i ... -o PasswordAuthentication=no <usuario>@<ip-do-pc>` retorna
    `Permission denied (publickey,password,keyboard-interactive)` — auth ainda
    falha, ou seja pubkey não está no arquivo (ou está com ACL errada).
  - Chave pública (adicionar como linha única no `authorized_keys`):
    ```
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCx/33S+CLcn0N9ZFwivh/5hNkv2fuZgY9esxyJRmJR quest3-termux-20260920
    ```
- [x] `claude` funcionando do lado do PC via essa sessão SSH — retorna
      `2.1.278 (Claude Code)`. Instalado em `C:\Users\<usuario>\.local\bin\claude.exe`,
      **não** está no `PATH` da sessão sshd (só usuário-interativo). Node
      v24.19.0 em `C:\Program Files\nodejs`. Precisa invocar por caminho
      completo por enquanto — refinar num Task 002 (adicionar `.local\bin`
      ao PATH do sistema ou criar alias no Termux).

## Task 001 — resultado final

**Concluído 2026-09-20.** Sessão Termux/Quest 3 agora consegue rodar Claude
Code no PC via SSH:

```bash
ssh -i ~/.ssh/id_ed25519_quest <usuario>@<ip-do-pc> 'C:\Users\<usuario>\.local\bin\claude.exe'
```

Próximos passos (novo Task) — adicionar `.local\bin` ao PATH do sshd + wrapper
`claudepc` no Termux + testar sessão interativa com TTY (`ssh -t`).

## Resposta à issue #1 (do lado do PC/host, PR #2 do PC)

- **IP:** `<ip-do-pc>` (Ethernet, não Wi-Fi — o PC não tem adaptador Wi-Fi;
  Quest e PC no mesmo roteador `192.168.x.x` — confirmado, TCP alcança).
- **Usuário Windows:** `<usuario>` → `ssh <usuario>@<ip-do-pc>`
- **sshd:** instalado via release oficial `PowerShell/Win32-OpenSSH`
  (MSI `10.0.0.0p2-Preview`, Win64) — DISM/capability do Windows falhou com
  `0x800f0950`, contornado com o instalador direto. Confirmado agora:
  `Status: Running`, `StartType: Automatic`, escutando em `0.0.0.0:22` e
  `[::]:22`.
- **Firewall:** regra `sshd` já criada e habilitada (Inbound, TCP 22, Allow).

## Convenção de labels (nova, 2026-09-20)

- `para-pc` — pedidos pra sessão Claude Code no PC
- `para-termux` — pedidos pra sessão Claude Code no Quest 3
- `para-julio` — pedidos pro humano (mudança de sistema, senha, decisão)

Issues abertos:

- #3 `[para-pc]` — pubkey em `administrators_authorized_keys` (PC sem admin, escalou)
- #4 `[para-julio]` — rodar PowerShell elevado (bloqueio real do passo 2)

## Task 002 — `claude` no PATH do sshd + wrapper `claudepc`

- [x] `claude` no PATH de sessão SSH não-interativa no PC — **resolvido sem
      admin**: `C:\Users\<usuario>\.local\bin` está no PATH de *usuário*, e o
      sshd do Windows carrega esse PATH. Testado 2026-09-25 a partir do Quest:
      `ssh ... <usuario>@<ip-do-pc> "where claude & claude --version"` →
      `C:\Users\<usuario>\.local\bin\claude.exe`, `2.1.283 (Claude Code)`.
      Não precisou mexer no PATH de sistema (Machine).
- [x] Wrapper `claudepc` no Termux — script versionado em
      `shortcuts/claudepc.sh`, instalado em `$PREFIX/bin/claudepc`. Usa o
      alias `pc` do `~/.ssh/config` do Termux (IP/usuário ficam só no
      device, fora do repo público). Sem argumentos: `ssh -t pc` + `claude
      --continue` em `C:\quest3-claude-ops`; com argumentos, repassa pro
      `claude`. Sempre com `--dangerously-skip-permissions` (pedido do
      Julio 2026-09-25 — testado: escrita de arquivo no PC sem prompt).
  - Teste headless 2026-09-25: `claudepc -p "reply with exactly: pong from
    pc via claudepc"` → `pong from pc via claudepc`, exit 0.
  - Alocação de TTY (`ssh -tt pc`) confirmada — abre conhost/ConPTY no PC.
- [ ] Sessão interativa real (`claudepc` digitado no Termux, com teclado no
      headset) — precisa ser testada pelo Julio no Quest; não dá pra
      validar interatividade de ponta a ponta disparando daqui.
